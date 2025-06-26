//
//  SpecialDaysView.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import SwiftUI

// ViewModel to manage the state and logic for the SpecialDaysView
@MainActor
class SpecialDaysViewModel: ObservableObject {
    @Published var currentSpecialDay: SpecialDay?
    @Published var generatedAffirmation: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let geminiService = GeminiService()

    init() {
        findCurrentSpecialDay()
    }

    func findCurrentSpecialDay() {
        let today = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        
        // This is a simple lookup. A more advanced version would handle calculated dates.
        self.currentSpecialDay = SpecialDaysData.days.first { $0.month == month && $0.day == day }
    }
    
    func generateAffirmationTapped() {
        guard let specialDay = currentSpecialDay else { return }
        
        isLoading = true
        generatedAffirmation = nil
        errorMessage = nil
        
        Task {
            do {
                let affirmation = try await geminiService.generateAffirmation(for: specialDay)
                self.generatedAffirmation = affirmation
            } catch {
                self.errorMessage = "Failed to generate affirmation: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}


struct SpecialDaysView: View {
    @StateObject private var viewModel = SpecialDaysViewModel()

    var body: some View {
        let themeColors = viewModel.currentSpecialDay?.theme.colors ?? [Color.black, Color.gray]
        
        ZStack {
            // Themed background
            LinearGradient(gradient: Gradient(colors: themeColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                .animation(.easeInOut, value: viewModel.currentSpecialDay?.name)

            VStack(spacing: 30) {
                if let specialDay = viewModel.currentSpecialDay {
                    // Title for the special day
                    Text(specialDay.theme.rawValue)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(specialDay.name)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: themeColors.last?.opacity(0.5) ?? .white, radius: 10)
                    
                    Spacer()
                    
                    // Generated affirmation display area
                    if viewModel.isLoading {
                        SwiftUI.ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                    } else if let affirmation = viewModel.generatedAffirmation {
                        Text(affirmation)
                            .font(.system(size: 22, weight: .medium, design: .serif))
                            .foregroundColor(.white)
                            .padding()
                            .background(.white.opacity(0.1))
                            .cornerRadius(16)
                            .multilineTextAlignment(.center)
                            .transition(.opacity.animation(.easeInOut))
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Button to generate affirmation
                    Button(action: viewModel.generateAffirmationTapped) {
                        HStack {
                            Image(systemName: "sparkle")
                            Text("Günün Olumlamasını Oluştur")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(themeColors.first ?? .black)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                    
                } else {
                    // Default view for a non-special day
                    Text("Bugün Takvimde Özel Bir Gün Yok")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Kendi manifestini yaratmak için harika bir gün!")
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
        }
    }
}

struct SpecialDaysView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialDaysView()
    }
} 