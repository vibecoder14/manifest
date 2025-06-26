//
//  ContentView.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import SwiftUI

// --- Views ---

struct ManifestView: View {
    // --- State ---
    @State private var wishText: String = ""
    @State private var repetitionCount: Int = 1
    @State private var isManifesting: Bool = false
    @State private var completedCount: Int = 0
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State private var useStraightAnimation: Bool = false
    @State private var useRoundedBubble: Bool = false

    @State private var stars: [Star] = []
    @State private var animatingWishes: [AnimatingWish] = []
    
    // Timer for wish repetition
    @State private var repetitionTimer: Timer?
    
    // --- Body ---
    private var manifestationLayer: some View {
        ZStack {
            ForEach(animatingWishes) { wish in
                Group {
                    WishBubble(text: wish.text, onCompleted: {
                        if let index = animatingWishes.firstIndex(where: { $0.id == wish.id }) {
                            animatingWishes.remove(at: index)
                        }
                    }, animationStyle: wish.animationStyle, bubbleType: wish.bubbleType)
                    
                    if let image = wish.image {
                        ImageBubble(image: image) {
                            // No need to remove here as it's handled by text bubble
                        }
                    }
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    CancelButton(action: toggleManifestation)
                }
                Spacer()
                ProgressView(completed: completedCount, total: repetitionCount)
                    .padding(.bottom, 20)
            }
            .padding()
        }
        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
    }
    
    private var inputLayer: some View {
        VStack(spacing: 20) {
            WishInputView(
                wishText: $wishText,
                selectedImage: $selectedImage,
                isImagePickerPresented: $isImagePickerPresented
            )
            
            if !isManifesting {
                VStack(spacing: 12) {
                    // Animation style toggle
                    Toggle(isOn: $useStraightAnimation) {
                        Text("Use straight upward animation")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal)
                    .tint(Color(hex: "FFB6C1"))
                    
                    // Bubble type toggle
                    Toggle(isOn: $useRoundedBubble) {
                        Text("Use speech bubble style")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.horizontal)
                    .tint(Color(hex: "FFB6C1"))
                }
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                RepetitionControlView(repetitionCount: $repetitionCount)
                ManifestButton(action: toggleManifestation)
            }
        }
        .padding(.bottom, 30)
    }
    
    var body: some View {
        ZStack {
            CosmicBackground(stars: $stars)
            
            VStack {
                Spacer()
                
                if isManifesting {
                    manifestationLayer
                } else {
                    inputLayer
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                }
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onAppear(perform: setupStars)
        .onChange(of: isManifesting) { newValue in
            if !newValue {
                repetitionTimer?.invalidate()
                animatingWishes.removeAll()
            }
        }
    }
    
    // --- Logic ---
    private func setupStars() {
        stars = (0..<100).map { _ in
            Star(
                position: CGPoint(x: .random(in: 0...UIScreen.main.bounds.width), y: .random(in: 0...UIScreen.main.bounds.height)),
                size: .random(in: 1...3),
                opacity: .random(in: 0.1...0.8),
                blur: .random(in: 0...1)
            )
        }
        
        // Star twinkling timer
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard let randomIndex = stars.indices.randomElement() else { return }
            stars[randomIndex].opacity = .random(in: 0.1...0.8)
            stars[randomIndex].size = .random(in: 1...3)
        }
    }
    
    private func toggleManifestation() {
        if isManifesting {
            isManifesting = false
        } else {
            guard !wishText.isEmpty, repetitionCount > 0 else { return }
            isManifesting = true
            completedCount = 0
            
            var count = 0
            let shouldShowImage = selectedImage != nil
            let imageFrequency = shouldShowImage ? 2 : 1
            
            repetitionTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                guard count < repetitionCount else {
                    timer.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 24.0) {
                        isManifesting = false
                        wishText = ""
                        selectedImage = nil
                    }
                    return
                }
                
                animatingWishes.append(AnimatingWish(
                    text: wishText,
                    image: shouldShowImage && count % imageFrequency == 0 ? selectedImage : nil,
                    animationStyle: useStraightAnimation ? .straight : .wavy,
                    bubbleType: useRoundedBubble ? .rounded : .circle
                ))
                
                completedCount += 1
                count += 1
            }
        }
    }
}

// --- Subviews ---

struct CosmicBackground: View {
    @Binding var stars: [Star]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            LinearGradient(gradient: Gradient(colors: [
                Color(hex: "FFDAB9").opacity(0.4),  // PeachPuff
                Color(hex: "E6E6FA").opacity(0.3),  // Lavender
                Color(hex: "D8BFD8").opacity(0.4)   // Thistle
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .blur(radius: 20)
            
            ForEach(stars) { star in
                Circle()
                    .fill(Color.white.opacity(star.opacity))
                    .frame(width: star.size, height: star.size)
                    .position(star.position)
                    .blur(radius: star.blur)
                    .animation(.easeInOut(duration: 0.2), value: star.opacity)
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack {
            Text("✨ Wish Bubble ✨")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: Color(hex: "FFDAB9"), radius: 10)

            Text("Your desires are on their way to you.")
                .font(.system(size: 16, weight: .light, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

struct WishInputView: View {
    @Binding var wishText: String
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                TextField("Type your wish...", text: $wishText, axis: .vertical)
            .lineLimit(5)
            .padding()
            .frame(minHeight: 100, alignment: .top)
            .background(Color.white.opacity(0.1))
                    .cornerRadius(25)
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .overlay(
                        RoundedRectangle(cornerRadius: 25)
                    .stroke(Color(hex: "FFDAB9").opacity(0.5), lineWidth: 1)
            )
                
                // Image picker button
                Button(action: { isImagePickerPresented = true }) {
                    Image(systemName: selectedImage == nil ? "photo.circle.fill" : "photo.circle.fill.badge.checkmark")
                        .font(.system(size: 24))
                        .foregroundColor(selectedImage == nil ? .white.opacity(0.6) : Color(hex: "FFB6C1"))
                        .padding(12)
                }
            }
            
            // Image preview if selected
            if let image = selectedImage {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                    
                    Button(action: { selectedImage = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 20))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

struct RepetitionControlView: View {
    @Binding var repetitionCount: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Text("Repeat:")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .medium, design: .rounded))
            
            TextField("", value: $repetitionCount, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 80)
                .padding(8)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(hex: "FFDAB9").opacity(0.5), lineWidth: 1)
                )
                .onChange(of: repetitionCount) { newValue in
                    if newValue > 777 { repetitionCount = 777 }
                    else if newValue < 1 { repetitionCount = 1 }
                }
        }
        .padding(.horizontal)
    }
}

struct ManifestButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Create Wish Bubble")
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "FFB6C1"),
                        Color(hex: "DDA0DD")
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(20)
            .shadow(color: Color(hex: "FFB6C1").opacity(0.5), radius: 10)
        }
        .padding(.horizontal)
    }
}

struct ProgressView: View {
    let completed: Int
    let total: Int
    
    var body: some View {
        Text("\(completed) / \(total) sent")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.8))
            .transition(.opacity)
    }
}

struct ManifestProgressView: View {
    let completed: Int
    let total: Int
    
    var body: some View {
        Text("\(completed) / \(total) sent")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.8))
            .transition(.opacity)
    }
}

struct CancelButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .padding(12)
                .background(Color.white.opacity(0.7))
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}

// Background shape for the bubble
struct BubbleBackground: View {
    let bubbleType: WishBubbleType
    let size: CGSize
    
    var body: some View {
        Group {
            switch bubbleType {
            case .circle:
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .background(.ultraThinMaterial)
            case .rounded:
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.2))
                    .background(.ultraThinMaterial)
                    .overlay(
                        // Speech bubble tail
                        Path { path in
                            let width = size.width
                            let height = size.height
                            path.move(to: CGPoint(x: width * 0.8, y: height))
                            path.addQuadCurve(
                                to: CGPoint(x: width * 0.9, y: height + 15),
                                control: CGPoint(x: width * 0.85, y: height)
                            )
                            path.addQuadCurve(
                                to: CGPoint(x: width * 0.7, y: height),
                                control: CGPoint(x: width * 0.8, y: height + 5)
                            )
                            path.closeSubpath()
                        }
                        .fill(Color.black.opacity(0.2))
                        .background(.ultraThinMaterial)
                    )
            }
        }
    }
}

// Bubble shape clipper
struct BubbleShape: Shape {
    let bubbleType: WishBubbleType
    
    func path(in rect: CGRect) -> Path {
        switch bubbleType {
        case .circle:
            return Circle().path(in: rect)
        case .rounded:
            return RoundedRectangle(cornerRadius: 20).path(in: rect)
        }
    }
}

struct WishBubble: View {
    let text: String
    let onCompleted: () -> Void
    let animationStyle: WishAnimationStyle
    let bubbleType: WishBubbleType
    
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0.0
    
    private var bubbleSize: CGSize {
        let textLength = text.count
        switch bubbleType {
        case .circle:
            let diameter = min(max(120, CGFloat(textLength) * 3), 200)
            return CGSize(width: diameter, height: diameter)
        case .rounded:
            let width = min(max(160, CGFloat(textLength) * 4), 250)
            let height = min(max(80, CGFloat(textLength) * 1.5), 120)
            return CGSize(width: width, height: height)
        }
    }
    
    private var animationDuration: Double {
        switch animationStyle {
        case .wavy:
            return Double.random(in: 12...24)
        case .straight:
            return 8.0
        }
    }

    var body: some View {
            Text(text)
            .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(20)
            .frame(width: bubbleSize.width, height: bubbleSize.height)
            .background(BubbleBackground(bubbleType: bubbleType, size: bubbleSize))
            .clipShape(BubbleShape(bubbleType: bubbleType))
            .shadow(color: Color(hex: "FFB6C1").opacity(0.5), radius: 10)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                
                // Set initial position and rotation
                switch animationStyle {
                case .wavy:
                    let randomX = CGFloat.random(in: -screenWidth/3...screenWidth/3)
                    offset = CGSize(width: randomX, height: screenHeight/2)
                    rotation = Double.random(in: -8...8)
                case .straight:
                    offset = CGSize(width: 0, height: screenHeight/2)
                    rotation = 0
                }
                
                // Fade in
                withAnimation(.easeOut(duration: 0.8)) {
                    opacity = 1.0
                }
                
                // Movement animation
                switch animationStyle {
                case .wavy:
                    withAnimation(
                        .interpolatingSpring(
                            duration: animationDuration,
                            bounce: 0.3,
                            initialVelocity: 0.1
                        )
                    ) {
                        let endX = CGFloat.random(in: -screenWidth/4...screenWidth/4)
                        offset = CGSize(
                            width: endX,
                            height: -screenHeight - 100
                        )
                        rotation = Double.random(in: -15...15)
                    }
                case .straight:
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        offset = CGSize(
                            width: 0,
                            height: -screenHeight - 100
                        )
                    }
                }
                
                // Fade out
                withAnimation(.easeIn(duration: 2.0).delay(animationDuration - 3.0)) {
                    opacity = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: onCompleted)
            }
    }
}

struct ImageBubble: View {
    let image: UIImage
    let onCompleted: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0.0
    
    // Fixed bubble size instead of random
    private let bubbleSize: CGFloat = 60
    
    // Random animation duration between 12 and 24 seconds
    private var animationDuration: Double {
        Double.random(in: 12...24)
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: bubbleSize, height: bubbleSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
            )
        .shadow(color: Color(hex: "FFB6C1").opacity(0.5), radius: 10)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .onAppear {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                
                // Random starting position at the bottom of the screen
                let randomX = CGFloat.random(in: -screenWidth/3...screenWidth/3)
                offset = CGSize(width: randomX, height: screenHeight/2)
                
                // Initial rotation
                rotation = Double.random(in: -8...8)
                
                // Fade in
                withAnimation(.easeOut(duration: 0.8)) {
                    opacity = 1.0
                }
                
                // Animate floating up with a wavy path
                withAnimation(
                    .interpolatingSpring(
                        duration: animationDuration,
                        bounce: 0.3,
                        initialVelocity: 0.1
                    )
                ) {
                    // Random end position
                    let endX = CGFloat.random(in: -screenWidth/4...screenWidth/4)
                    offset = CGSize(
                        width: endX,
                        height: -screenHeight - 100
                    )
                    rotation = Double.random(in: -15...15)
                }
                
                // Fade out near the end of the animation
                withAnimation(.easeIn(duration: 2.0).delay(animationDuration - 3.0)) {
                opacity = 0
            }
            
            // Notify parent to remove this wish from the array after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: onCompleted)
        }
    }
}

// Image Picker View
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
