import SwiftUI
import Combine

// A single energy particle
struct EnergyParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double = 1.0
    var progress: Double = 0.0
}

// Energy Flow Animation View
struct EnergyFlowView: View {
    let fromPosition: CGPoint
    let toPosition: CGPoint
    let onCompleted: () -> Void
    var config: EnergyAnimationConfig = EnergyAnimationConfig()
    
    @State private var particles: [EnergyParticle] = []
    @State private var isAnimating: Bool = false
    @State private var burstScale: CGFloat = 0.0
    @State private var burstOpacity: Double = 0.0
    
    // Create a curved path from source to destination
    private func createPath() -> Path {
        let controlPoint1 = CGPoint(
            x: fromPosition.x + (toPosition.x - fromPosition.x) * 0.5,
            y: fromPosition.y - 100
        )
        
        let controlPoint2 = CGPoint(
            x: toPosition.x - (toPosition.x - fromPosition.x) * 0.3,
            y: toPosition.y + 50
        )
        
        var path = Path()
        path.move(to: fromPosition)
        path.addCurve(to: toPosition, 
                     control1: controlPoint1, 
                     control2: controlPoint2)
        return path
    }
    
    // Get point at specific progress along the path
    private func point(at progress: Double) -> CGPoint {
        // Calculate point along the Bezier curve
        let t = CGFloat(progress)
        let start = fromPosition
        let end = toPosition
        
        // Control points for the curve
        let controlPoint1 = CGPoint(
            x: start.x + (end.x - start.x) * 0.5,
            y: start.y - 100
        )
        
        let controlPoint2 = CGPoint(
            x: end.x - (end.x - start.x) * 0.3,
            y: end.y + 50
        )
        
        // Cubic Bezier formula: B(t) = (1-t)³P₀ + 3(1-t)²tP₁ + 3(1-t)t²P₂ + t³P₃
        let t1 = (1 - t)
        let t2 = t1 * t1
        let t3 = t2 * t1
        let s1 = 3 * t2 * t
        let s2 = 3 * t1 * t * t
        let s3 = t * t * t
        
        let x = t3 * start.x + s1 * controlPoint1.x + s2 * controlPoint2.x + s3 * end.x
        let y = t3 * start.y + s1 * controlPoint1.y + s2 * controlPoint2.y + s3 * end.y
        
        return CGPoint(x: x, y: y)
    }
    
    var body: some View {
        ZStack {
            // Particles
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .blur(radius: particle.size * 0.2)
            }
            
            // Burst effect at destination
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "FFB6C1").opacity(0.8),
                            Color(hex: "FFB6C1").opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 1,
                        endRadius: 50
                    )
                )
                .frame(width: 80, height: 80)
                .scaleEffect(burstScale)
                .opacity(burstOpacity)
                .position(toPosition)
                .blur(radius: 3)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Initialize particles
        particles = (0..<config.particleCount).map { _ in
            EnergyParticle(
                position: fromPosition,
                size: CGFloat.random(in: config.particleSize),
                color: config.particleColors.randomElement() ?? .pink
            )
        }
        
        // Animate each particle along the path with slight variations
        isAnimating = true
        
        // Start animation for each particle with slight delay
        for i in 0..<particles.count {
            let delay = Double(i) * 0.05
            
            // Animate particle along the path
            withAnimation(.easeInOut(duration: config.duration).delay(delay)) {
                particles[i].progress = 1.0
            }
            
            // Update particle position in real time based on progress
            let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            
            timer.sink { _ in
                if isAnimating && particles[i].progress < 1.0 {
                    particles[i].position = point(at: particles[i].progress)
                }
            }
            .store(in: &cancellables)
                
            // Fade out at the end
            withAnimation(.easeOut(duration: 0.3).delay(config.duration + delay - 0.2)) {
                particles[i].opacity = 0
            }
        }
        
        // Trigger burst effect at destination
        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration - 0.1) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                burstScale = 1.0
                burstOpacity = 0.8
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                burstOpacity = 0
            }
        }
        
        // Call completion handler
        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration + 0.5) {
            isAnimating = false
            onCompleted()
        }
    }
    
    // For cancelling timers
    @State private var cancellables = Set<AnyCancellable>()
}

// Preview
struct EnergyFlowView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            EnergyFlowView(
                fromPosition: CGPoint(x: 100, y: 600),
                toPosition: CGPoint(x: 300, y: 300),
                onCompleted: {}
            )
        }
    }
} 