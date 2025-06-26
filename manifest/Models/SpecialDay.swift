//
//  SpecialDay.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import Foundation
import SwiftUI

// Defines the category of a special day, which will determine its theme.
enum SpecialDayTheme: String, CaseIterable {
    case lunar = "Ay Dönümü"
    case cultural = "Kültürel"
    case national = "Ulusal"
    case universal = "Evrensel"
    case spiritual = "Manevi"
    case fun = "Eğlenceli"
    case remembrance = "Anma"
    
    // Provides a specific color palette for each theme.
    var colors: [Color] {
        switch self {
        case .lunar:
            return [Color(hex: "000080"), Color(hex: "C0C0C0"), Color(hex: "E6E6FA")] // Navy, Silver, Lavender
        case .cultural:
            return [Color(hex: "FF7F50"), Color(hex: "8A2BE2"), Color(hex: "DEB887")] // Coral, BlueViolet, BurlyWood
        case .national:
            return [Color(hex: "FF0000"), Color(hex: "FFFFFF")] // Red, White (Can be adapted)
        case .universal:
            return [Color(hex: "2E8B57"), Color(hex: "4682B4"), Color(hex: "90EE90")] // SeaGreen, SteelBlue, LightGreen
        case .spiritual:
            return [Color(hex: "FFD700"), Color(hex: "DA70D6"), Color(hex: "F0E68C")] // Gold, Orchid, Khaki
        case .fun:
            return [Color(hex: "FF69B4"), Color(hex: "1E90FF"), Color(hex: "FFFF00")] // HotPink, DodgerBlue, Yellow
        case .remembrance:
            return [Color(hex: "2F4F4F"), Color(hex: "A9A9A9"), Color(hex: "FFFFFF")] // DarkSlateGray, DarkGray, White
        }
    }
}

// Represents a single special day.
struct SpecialDay {
    let month: Int
    let day: Int
    let name: String
    let theme: SpecialDayTheme
    
    // Some special days are on a fixed date, some are calculated.
    // This initializer is for fixed dates.
    init(month: Int, day: Int, name: String, theme: SpecialDayTheme) {
        self.month = month
        self.day = day
        self.name = name
        self.theme = theme
    }
    
    // TODO: Add initializers for calculated dates like Easter or the 2nd Sunday of May.
} 