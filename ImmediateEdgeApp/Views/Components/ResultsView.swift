//
//  ResultsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ResultsView: View {
    let wpm: Int?
    let comprehensionScore: Float?
    let wordsRead: Int
    let duration: Int // in seconds
    let previousWPM: Int?
    let onDone: () -> Void
    let onTryAgain: (() -> Void)?

    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.extraLarge) {
                // Header
                VStack(spacing: DesignSystem.Spacing.small) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(DesignSystem.Colors.success)

                    Text("resultsTitle".localized)
                        .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))

                    Text(motivationalMessage)
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, DesignSystem.Spacing.extraLarge)

                // Results Cards
                VStack(spacing: DesignSystem.Spacing.medium) {
                    // WPM Card
                    if let wpm = wpm {
                        ResultCard(
                            title: "resultsWPM".localized,
                            value: "\(wpm)",
                            icon: "speedometer",
                            color: speedColor(wpm),
                            improvement: improvement
                        )
                    }

                    // Comprehension Card
                    if let comprehension = comprehensionScore {
                        ResultCard(
                            title: "resultsComprehension".localized,
                            value: comprehension.percentageString,
                            icon: "brain.head.profile",
                            color: comprehensionColor(comprehension)
                        )
                    }

                    // Words Read Card
                    ResultCard(
                        title: "resultsWordsRead".localized,
                        value: "\(wordsRead)",
                        icon: "text.book.closed",
                        color: .blue
                    )

                    // Time Card
                    ResultCard(
                        title: "resultsTime".localized,
                        value: duration.formattedTime,
                        icon: "clock",
                        color: .purple
                    )
                }

                // Action Buttons
                VStack(spacing: DesignSystem.Spacing.medium) {
                    PrimaryButton(title: "done".localized, action: onDone)

                    if let tryAgain = onTryAgain {
                        SecondaryButton(title: "buttonTryAgain".localized, action: tryAgain)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }

    private var motivationalMessage: String {
        if let wpm = wpm {
            let category = WPMCalculator.speedCategory(wpm: wpm)
            return category.description
        }
        return "Great job completing this exercise!"
    }

    private var improvement: String? {
        guard let wpm = wpm, let previousWPM = previousWPM, previousWPM > 0 else {
            return nil
        }
        let diff = wpm - previousWPM
        let percentage = Float(diff) / Float(previousWPM) * 100
        if diff > 0 {
            return "+\(diff) WPM (+\(String(format: "%.1f", percentage))%)"
        } else if diff < 0 {
            return "\(diff) WPM (\(String(format: "%.1f", percentage))%)"
        }
        return nil
    }

    private func speedColor(_ wpm: Int) -> Color {
        let category = WPMCalculator.speedCategory(wpm: wpm)
        switch category {
        case .slow: return .red
        case .average: return .orange
        case .good: return .blue
        case .excellent: return .green
        case .exceptional: return .purple
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
}

struct ResultCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var improvement: String? = nil

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            // Icon
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: DesignSystem.Typography.subhead))
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    if let improvement = improvement {
                        Text(improvement)
                            .font(.system(size: DesignSystem.Typography.caption, weight: .medium))
                            .foregroundColor(DesignSystem.Colors.success)
                    }
                }
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.medium)
        .cardStyle()
    }
}

#Preview {
    NavigationView {
        ResultsView(
            wpm: 320,
            comprehensionScore: 0.85,
            wordsRead: 450,
            duration: 90,
            previousWPM: 280,
            onDone: {},
            onTryAgain: {}
        )
    }
}
