//
//  Star.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import Foundation
import CoreGraphics

struct Star: Identifiable, Equatable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var blur: CGFloat
    
    // Conformance to Equatable
    static func == (lhs: Star, rhs: Star) -> Bool {
        lhs.id == rhs.id
    }
} 