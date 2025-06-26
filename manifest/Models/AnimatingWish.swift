//
//  AnimatingWish.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import SwiftUI

enum WishAnimationStyle {
    case wavy    // Original style with random movements
    case straight // New style with straight upward movement
}

enum WishBubbleType {
    case circle     // Original circular bubble
    case rounded    // Rounded rectangle speech bubble
}

struct AnimatingWish: Identifiable {
    let id = UUID()
    let text: String
    let image: UIImage?
    let animationStyle: WishAnimationStyle
    let bubbleType: WishBubbleType
    
    init(text: String, 
         image: UIImage? = nil, 
         animationStyle: WishAnimationStyle = .wavy,
         bubbleType: WishBubbleType = .circle) {
        self.text = text
        self.image = image
        self.animationStyle = animationStyle
        self.bubbleType = bubbleType
    }
} 