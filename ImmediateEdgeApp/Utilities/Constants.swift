//
//  Constants.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

// MARK: - App Constants
enum AppConstants {
    static let appName = "Immediate Edge"
    static let minimumIOSVersion = "15.0"
    static let defaultWPM = 250
    static let supportEmail = "support@immediateedge.app"
    static let privacyPolicyURL = "https://carter345clymond.github.io/immediate_edge_policy/privacy-policy.html"
    static let termsOfServiceURL = "https://carter345clymond.github.io/immediate_edge_policy/terms-of-service.html"
}

// MARK: - Design System
enum DesignSystem {
    // MARK: - Colors
    enum Colors {
        // Light Theme - Modern Gradient-Ready Palette
        static let primaryLight = Color(hex: "#6366F1")        // Vibrant Indigo
        static let secondaryLight = Color(hex: "#8B5CF6")      // Royal Purple
        static let accentLight = Color(hex: "#EC4899")         // Hot Pink
        static let backgroundLight = Color(hex: "#F8FAFC")     // Soft Cool White
        static let secondaryBackgroundLight = Color(hex: "#F1F5F9")  // Light Slate
        static let cardBackgroundLight = Color(hex: "#FFFFFF")
        static let textPrimaryLight = Color(hex: "#1E293B")    // Slate 800
        static let textSecondaryLight = Color(hex: "#64748B")  // Slate 500
        static let successLight = Color(hex: "#10B981")        // Emerald
        static let warningLight = Color(hex: "#F59E0B")        // Amber
        static let errorLight = Color(hex: "#EF4444")          // Red
        static let infoLight = Color(hex: "#3B82F6")           // Blue

        // Dark Theme - Rich Dark Palette
        static let primaryDark = Color(hex: "#818CF8")         // Lighter Indigo
        static let secondaryDark = Color(hex: "#A78BFA")       // Lighter Purple
        static let accentDark = Color(hex: "#F472B6")          // Lighter Pink
        static let backgroundDark = Color(hex: "#0F172A")      // Slate 900
        static let secondaryBackgroundDark = Color(hex: "#1E293B")  // Slate 800
        static let cardBackgroundDark = Color(hex: "#334155")  // Slate 700
        static let textPrimaryDark = Color(hex: "#F1F5F9")     // Slate 100
        static let textSecondaryDark = Color(hex: "#94A3B8")   // Slate 400
        static let successDark = Color(hex: "#34D399")         // Emerald
        static let warningDark = Color(hex: "#FBBF24")         // Amber
        static let errorDark = Color(hex: "#F87171")           // Red
        static let infoDark = Color(hex: "#60A5FA")            // Blue

        // Adaptive Colors - Auto-switching based on appearance
        static let primary = Color(hex: "#6366F1")
        static let secondary = Color(hex: "#8B5CF6")
        static let accent = Color(hex: "#EC4899")
        static let background = Color(hex: "#FFFEF0")        // Light Yellow Background
        static let secondaryBackground = Color(hex: "#FFFBEB") // Slightly darker yellow
        static let cardBackground = Color(hex: "#FFFFFF")
        static let textPrimary = Color(hex: "#1E293B")
        static let textSecondary = Color(hex: "#64748B")
        static let success = Color(hex: "#10B981")
        static let warning = Color(hex: "#F59E0B")
        static let error = Color(hex: "#EF4444")
        static let info = Color(hex: "#3B82F6")

        // Gradient Colors
        static let gradientStart = Color(hex: "#6366F1")
        static let gradientEnd = Color(hex: "#8B5CF6")

        // Exercise Specific Colors
        static let rsvpColor = Color(hex: "#3B82F6")      // Blue
        static let schulteColor = Color(hex: "#8B5CF6")   // Purple
        static let chunkingColor = Color(hex: "#EC4899")  // Pink
    }

    // MARK: - Typography
    enum Typography {
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subhead: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption: CGFloat = 12

        // Reading Text Sizes
        static let readingSmall: CGFloat = 16
        static let readingMedium: CGFloat = 18
        static let readingLarge: CGFloat = 22
    }

    // MARK: - Spacing
    enum Spacing {
        static let extraSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }

    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }

    // MARK: - Shadows
    enum Shadow {
        static let small = ShadowStyle(radius: 4, y: 2, opacity: 0.1)
        static let medium = ShadowStyle(radius: 8, y: 4, opacity: 0.15)
        static let large = ShadowStyle(radius: 16, y: 8, opacity: 0.2)
    }
}

// MARK: - Shadow Style
struct ShadowStyle {
    let radius: CGFloat
    let y: CGFloat
    let opacity: Double
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Exercise Settings
enum ExerciseSettings {
    // RSVP Settings
    enum RSVP {
        static let minSpeed = 100
        static let maxSpeed = 600
        static let defaultSpeed = 250
        static let durations = [3, 5, 10]
        static let wordsPerDisplay = [1, 2, 3]
    }

    // Schulte Settings
    enum Schulte {
        static let easyGridSize = 5
        static let mediumGridSize = 7
        static let rounds = [1, 3, 5]
    }

    // Chunking Settings
    enum Chunking {
        static let chunkSizes = [2, 3, 4, 5]
        static let defaultChunkSize = 3
        static let speeds = ["Slow", "Medium", "Fast", "Very Fast"]
        static let durations = [5, 10, 15]
    }
}
