import SwiftUI

// User Model
struct User: Identifiable {
    var id: String = UUID().uuidString
    var username: String
    var profileImageURL: URL?
    var createdWishes: Int = 0
    var energySent: Int = 0
    var joinedDate: Date = Date()
}

// Extended Wish Model for Social Sharing
struct SocialWish: Identifiable {
    var id: String = UUID().uuidString
    var userId: String
    var username: String
    var userProfileImageURL: URL?
    var text: String
    var imageURL: URL?
    var isPublic: Bool = true
    var energyCount: Int = 0
    var createdAt: Date = Date()
    
    // UI properties
    var animationStyle: WishAnimationStyle = .wavy
    var bubbleType: WishBubbleType = .circle
}

// Energy Transfer Model
struct EnergyTransfer: Identifiable {
    var id: String = UUID().uuidString
    var fromUserId: String
    var fromUsername: String
    var toWishId: String
    var amount: Int = 1
    var timestamp: Date = Date()
}

// Energy Animation Configuration
struct EnergyAnimationConfig {
    var particleCount: Int = 15
    var duration: Double = 2.0
    var particleSize: ClosedRange<CGFloat> = 3...8
    var particleColors: [Color] = [
        Color(hex: "FFB6C1"),  // Light pink
        Color(hex: "DDA0DD"),  // Plum
        Color(hex: "FFDAB9"),  // Peach
        Color(hex: "E6E6FA")   // Lavender
    ]
} 