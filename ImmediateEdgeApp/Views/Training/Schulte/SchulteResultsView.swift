//
//  SchulteResultsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct SchulteResultsView: View {
    let difficulty: SchulteSettingsView.SchulteDifficulty
    let totalRounds: Int
    let roundTimes: [TimeInterval]
    let incorrectTaps: Int

    @Environment(\.dismiss) var dismiss

    private var averageTime: TimeInterval {
        guard !roundTimes.isEmpty else { return 0 }
        return roundTimes.reduce(0, +) / Double(roundTimes.count)
    }

    private var bestTime: TimeInterval {
        roundTimes.min() ?? 0
    }

    private var accuracy: Float {
        let totalCells = difficulty.gridSize * difficulty.gridSize
        let totalPossibleTaps = totalCells * roundTimes.count
        let correctTaps = totalPossibleTaps - incorrectTaps
        return Float(correctTaps) / Float(totalPossibleTaps)
    }

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
                VStack(spacing: 8) {
                    Text("trainingComplete".localized)
                        .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text(difficulty.displayName + " • \(totalRounds) " + "rounds".localized)
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                // Results Cards
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ResultStatCard(
                        title: "avg time".localized,
                        value: formatTime(averageTime),
                        icon: "timer",
                        color: .blue
                    )

                    ResultStatCard(
                        title: "best time".localized,
                        value: formatTime(bestTime),
                        icon: "crown.fill",
                        color: .orange
                    )

                    ResultStatCard(
                        title: "trainingAccuracy".localized,
                        value: accuracy.percentageString,
                        icon: "target",
                        color: accuracyColor
                    )

                    if incorrectTaps > 0 {
                        ResultStatCard(
                            title: "mistakes".localized,
                            value: "\(incorrectTaps)",
                            icon: "xmark.circle",
                            color: .red
                        )
                    }
                }
                .padding(.horizontal)

                // Round Times Breakdown
                if roundTimes.count > 1 {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("breakdown".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        VStack(spacing: DesignSystem.Spacing.small) {
                            ForEach(Array(roundTimes.enumerated()), id: \.offset) { index, time in
                                HStack {
                                    Text("\("round".localized) \(index + 1)")
                                        .font(.system(size: DesignSystem.Typography.body))
                                        .foregroundColor(DesignSystem.Colors.textSecondary)

                                    Spacer()

                                    Text(formatTime(time))
                                        .font(.system(size: DesignSystem.Typography.body, weight: .semibold))
                                        .foregroundColor(DesignSystem.Colors.textPrimary)

                                    if time == bestTime {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(DesignSystem.Colors.secondaryBackground)
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

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
                            dismiss()
                        }
                    )

                    SecondaryButton(
                        title: "buttonTryAgain".localized,
                        action: {
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

    private var accuracyColor: Color {
        switch accuracy {
        case 0.95...1.0: return .green
        case 0.85..<0.95: return .blue
        case 0.75..<0.85: return .orange
        default: return .red
        }
    }

    private var motivationalMessage: String {
        switch averageTime {
        case 0..<30:
            return "Exceptional! Your peripheral vision is extremely well developed."
        case 30..<45:
            return "Excellent performance! You're mastering peripheral vision training."
        case 45..<60:
            return "Great work! Keep practicing to improve your speed."
        default:
            return "Good effort! Regular practice will significantly improve your times."
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        let ms = Int((seconds.truncatingRemainder(dividingBy: 1)) * 100)

        if mins > 0 {
            return String(format: "%d:%02d.%02d", mins, secs, ms)
        } else {
            return String(format: "%d.%02d sec", secs, ms)
        }
    }
}

#Preview {
    NavigationView {
        SchulteResultsView(
            difficulty: .easy,
            totalRounds: 3,
            roundTimes: [28.5, 25.3, 26.8],
            incorrectTaps: 2
        )
    }
}
