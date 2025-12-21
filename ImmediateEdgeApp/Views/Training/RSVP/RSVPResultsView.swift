//
//  RSVPResultsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct RSVPResultsView: View {
    let wordsRead: Int
    let averageWPM: Int
    let timeSpent: Int // seconds
    let comprehensionScore: Float?

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.extraLarge) {
                Spacer()
                    .frame(height: 20)

                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(DesignSystem.Colors.success)

                // Title
                Text("trainingComplete".localized)
                    .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                // Results Cards
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ResultStatCard(
                        title: "wordsRead".localized,
                        value: "\(wordsRead)",
                        icon: "text.word.spacing",
                        color: .blue
                    )

                    ResultStatCard(
                        title: "averageSpeed".localized,
                        value: "\(averageWPM) WPM",
                        icon: "speedometer",
                        color: speedColor
                    )

                    ResultStatCard(
                        title: "timeSpent".localized,
                        value: formatTime(timeSpent),
                        icon: "clock.fill",
                        color: .purple
                    )

                    if let comprehension = comprehensionScore {
                        ResultStatCard(
                            title: "comprehensionRate".localized,
                            value: comprehension.percentageString,
                            icon: "brain.head.profile",
                            color: comprehensionColor(comprehension)
                        )
                    }
                }
                .padding(.horizontal)

                // Motivational Message
                Text(motivationalMessage)
                    .font(.system(size: DesignSystem.Typography.body))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.large)

                // Buttons
                VStack(spacing: DesignSystem.Spacing.medium) {
                    PrimaryButton(
                        title: "done".localized,
                        action: {
                            // Navigate back to training selection
                            dismiss()
                        }
                    )

                    SecondaryButton(
                        title: "buttonTryAgain".localized,
                        action: {
                            // Go back to try again
                            dismiss()
                        }
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.large)

                Spacer()
                    .frame(height: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private var speedColor: Color {
        let category = WPMCalculator.speedCategory(wpm: averageWPM)
        switch category {
        case .slow: return .orange
        case .average: return .blue
        case .good: return .green
        case .excellent, .exceptional: return .purple
        }
    }

    private func comprehensionColor(_ score: Float) -> Color {
        switch score {
        case 0.9...1.0: return .green
        case 0.8..<0.9: return .blue
        case 0.7..<0.8: return .orange
        default: return .red
        }
    }

    private var motivationalMessage: String {
        let category = WPMCalculator.speedCategory(wpm: averageWPM)
        return category.description + " " + "keepPracticing".localized
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        if minutes > 0 {
            return "\(minutes) min \(remainingSeconds) sec"
        } else {
            return "\(remainingSeconds) sec"
        }
    }
}

// MARK: - Result Stat Card
struct ResultStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: DesignSystem.Typography.body))
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                Text(value)
                    .font(.system(size: DesignSystem.Typography.title2, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
            }

            Spacer()
        }
        .padding()
        .cardStyle()
    }
}

#Preview {
    NavigationView {
        RSVPResultsView(
            wordsRead: 850,
            averageWPM: 280,
            timeSpent: 300,
            comprehensionScore: 0.85
        )
    }
}
