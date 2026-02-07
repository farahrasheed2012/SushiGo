//
//  Theme.swift
//  SushiGo
//
//  Sushi-themed colors and styling for the app.
//

import SwiftUI

enum Theme {
    // MARK: - Colors

    static let primary = Color(red: 0.85, green: 0.22, blue: 0.22)       // sushi red
    static let primaryDark = Color(red: 0.65, green: 0.12, blue: 0.12)
    static let accent = Color(red: 0.95, green: 0.75, blue: 0.35)        // ginger gold
    static let background = Color(red: 0.98, green: 0.96, blue: 0.92)   // rice paper
    static let cardBackground = Color(red: 1.0, green: 0.99, blue: 0.96)
    static let surface = Color.white
    static let text = Color(red: 0.2, green: 0.15, blue: 0.12)
    static let textSecondary = Color(red: 0.45, green: 0.4, blue: 0.35)
    static let success = Color(red: 0.2, green: 0.6, blue: 0.4)
    static let makiGreen = Color(red: 0.3, green: 0.55, blue: 0.35)
    static let seaweed = Color(red: 0.15, green: 0.35, blue: 0.25)

    // MARK: - Layout

    static let cornerRadius: CGFloat = 12
    static let cardCornerRadius: CGFloat = 10
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
}
