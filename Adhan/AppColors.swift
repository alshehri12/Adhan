//
//  AppColors.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI

struct AppColors {
    // Primary Color Palette
    static let primary = Color(red: 74/255, green: 144/255, blue: 226/255) // #4A90E2 - Spiritual Blue
    static let accent = Color(red: 212/255, green: 175/255, blue: 55/255) // #D4AF37 - Gold Accent
    static let secondary = Color(red: 109/255, green: 182/255, blue: 125/255) // #6DB67D - Soft Green
    
    // Background Colors
    static let backgroundLight = Color(red: 250/255, green: 250/255, blue: 250/255) // Off-white
    static let backgroundDark = Color(red: 25/255, green: 35/255, blue: 45/255) // Deep Blue-Gray
    
    // Text Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textAccent = accent
    
    // Card Colors
    static let cardBackground = Color(.systemBackground)
    static let cardBackgroundSecondary = Color(.secondarySystemBackground)
    
    // Gradient Colors
    static let gradientStart = primary.opacity(0.8)
    static let gradientEnd = primary.opacity(0.4)
} 