//
//  RSVPSettingsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct RSVPSettingsView: View {
    @State private var speed: Double = 250 // WPM
    @State private var duration: Int = 5 // minutes
    @State private var wordsPerDisplay: Int = 1
    @State private var fontSize: FontSizeOption = .medium
    @State private var navigateToTraining = false

    @Environment(\.dismiss) var dismiss

    enum FontSizeOption: String, CaseIterable {
        case small, medium, large

        var displayName: String {
            switch self {
            case .small: return "small".localized
            case .medium: return "difficultyMedium".localized
            case .large: return "large".localized
            }
        }

        var size: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 48
            case .large: return 64
            }
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraLarge) {
                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("rsvp".localized)
                            .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        Text("rsvp subtitle".localized)
                            .font(.system(size: DesignSystem.Typography.body))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }

                    // Speed Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        HStack {
                            Text("rsvp speed".localized)
                                .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                            Spacer()
                            Text("\(Int(speed)) WPM")
                                .font(.system(size: DesignSystem.Typography.headline, weight: .bold))
                                .foregroundColor(DesignSystem.Colors.primary)
                        }

                        Slider(value: $speed, in: 100...600, step: 25)
                            .tint(DesignSystem.Colors.primary)

                        HStack {
                            Text("100 WPM")
                                .font(.system(size: DesignSystem.Typography.caption))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                            Spacer()
                            Text("600 WPM")
                                .font(.system(size: DesignSystem.Typography.caption))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding()
                    .cardStyle()

                    // Duration Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("sessionLength".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        HStack(spacing: DesignSystem.Spacing.small) {
                            DurationButton(duration: 3, isSelected: duration == 3) {
                                duration = 3
                            }
                            DurationButton(duration: 5, isSelected: duration == 5) {
                                duration = 5
                            }
                            DurationButton(duration: 10, isSelected: duration == 10) {
                                duration = 10
                            }
                        }
                    }

                    // Words Per Display
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("rsvp words".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        HStack(spacing: DesignSystem.Spacing.small) {
                            WordsButton(words: 1, isSelected: wordsPerDisplay == 1) {
                                wordsPerDisplay = 1
                            }
                            WordsButton(words: 2, isSelected: wordsPerDisplay == 2) {
                                wordsPerDisplay = 2
                            }
                            WordsButton(words: 3, isSelected: wordsPerDisplay == 3) {
                                wordsPerDisplay = 3
                            }
                        }
                    }

                    // Font Size
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("settingFontSize".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        HStack(spacing: DesignSystem.Spacing.small) {
                            ForEach(FontSizeOption.allCases, id: \.self) { size in
                                FontSizeButton(
                                    option: size,
                                    isSelected: fontSize == size
                                ) {
                                    fontSize = size
                                }
                            }
                        }
                    }

                    // Start Button
                    PrimaryButton(
                        title: "buttonBeginJourney".localized,
                        action: {
                            navigateToTraining = true
                        }
                    )
                    .padding(.top, DesignSystem.Spacing.medium)
                }
                .padding()
            }
            .navigationTitle("trainingRSVPName".localized)
            .navigationBarTitleDisplayMode(.inline)

            // Hidden NavigationLink (iOS 15 compatible)
            NavigationLink(
                destination: RSVPTrainingView(
                    speed: speed,
                    duration: duration,
                    wordsPerDisplay: wordsPerDisplay,
                    fontSize: fontSize.size
                ),
                isActive: $navigateToTraining
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
}

// MARK: - Duration Button
struct DurationButton: View {
    let duration: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(duration) min")
                .font(.system(size: DesignSystem.Typography.body, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
                .cornerRadius(DesignSystem.CornerRadius.medium)
        }
    }
}

// MARK: - Words Button
struct WordsButton: View {
    let words: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(words)")
                    .font(.system(size: DesignSystem.Typography.title2, weight: .bold))
                Text(words == 1 ? "word".localized : "words".localized)
                    .font(.system(size: DesignSystem.Typography.caption))
            }
            .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
        }
    }
}

// MARK: - Font Size Button
struct FontSizeButton: View {
    let option: RSVPSettingsView.FontSizeOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(option.displayName)
                .font(.system(size: DesignSystem.Typography.body, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
                .cornerRadius(DesignSystem.CornerRadius.medium)
        }
    }
}

#Preview {
    NavigationView {
        RSVPSettingsView()
    }
}
