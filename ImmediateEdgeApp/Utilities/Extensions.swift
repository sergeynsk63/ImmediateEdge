//
//  Extensions.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

// MARK: - View Extensions
extension View {
    /// Applies a modern card style with shadow and corner radius
    func cardStyle(
        backgroundColor: Color = DesignSystem.Colors.cardBackground,
        cornerRadius: CGFloat = DesignSystem.CornerRadius.large,
        shadow: ShadowStyle = DesignSystem.Shadow.medium
    ) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(
                color: Color.black.opacity(0.06),
                radius: shadow.radius,
                y: shadow.y
            )
    }

    /// Applies primary button style with solid color
    func primaryButtonStyle() -> some View {
        self
            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(DesignSystem.Colors.primary)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .shadow(
                color: DesignSystem.Colors.primary.opacity(0.3),
                radius: 8,
                y: 4
            )
    }

    /// Applies secondary button style with solid border
    func secondaryButtonStyle() -> some View {
        self
            .font(.system(size: DesignSystem.Typography.headline, weight: .medium))
            .foregroundColor(DesignSystem.Colors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(DesignSystem.Colors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.primary, lineWidth: 2)
            )
            .cornerRadius(DesignSystem.CornerRadius.medium)
    }

    /// Adds haptic feedback on tap
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.onTapGesture {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
}

// MARK: - String Extensions
extension String {
    /// Returns localized string
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// Returns word count
    var wordCount: Int {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        return words.count
    }

    /// Splits string into chunks
    func chunked(size: Int) -> [String] {
        let words = self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        var chunks: [String] = []

        for i in stride(from: 0, to: words.count, by: size) {
            let chunk = words[i..<min(i + size, words.count)].joined(separator: " ")
            chunks.append(chunk)
        }

        return chunks
    }
}

// MARK: - Date Extensions
extension Date {
    /// Returns true if date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Returns true if date is yesterday
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Returns formatted date string
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Returns time ago string (e.g., "2 hours ago")
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Returns start of day
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Checks if two dates are on the same day
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
}

// MARK: - Int Extensions
extension Int {
    /// Formats time in seconds to MM:SS or HH:MM:SS
    var formattedTime: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60

        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    /// Formats number with thousands separator
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

// MARK: - Float Extensions
extension Float {
    /// Converts to percentage string
    var percentageString: String {
        String(format: "%.0f%%", self * 100)
    }

    /// Rounds to decimal places
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - Double Extensions
extension Double {
    /// Converts to percentage string
    var percentageString: String {
        String(format: "%.0f%%", self * 100)
    }
}

// MARK: - Array Extensions
extension Array where Element: Hashable {
    /// Removes duplicates while preserving order
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let currentUserId = "currentUserId"
        static let appLanguage = "appLanguage"
        static let lastAppVersion = "lastAppVersion"
    }

    var hasCompletedOnboarding: Bool {
        get { bool(forKey: Keys.hasCompletedOnboarding) }
        set { set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }

    var currentUserId: String? {
        get { string(forKey: Keys.currentUserId) }
        set { set(newValue, forKey: Keys.currentUserId) }
    }

    var appLanguage: String {
        get { string(forKey: Keys.appLanguage) ?? "en" }
        set { set(newValue, forKey: Keys.appLanguage) }
    }
}
