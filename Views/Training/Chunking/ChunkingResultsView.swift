//
//  ChunkingResultsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ChunkingResultsView: View {
    let chunksRead: Int
    let chunkSize: Int
    let timeSpent: Int

    @Environment(\.dismiss) var dismiss

    private var wordsRead: Int {
        chunksRead * chunkSize
    }

    private var averageWPM: Int {
        guard timeSpent > 0 else { return 0 }
        let minutes = Double(timeSpent) / 60.0
        return Int(Double(wordsRead) / minutes)
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
                Text("trainingComplete".localized)
                    .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                // Results Cards
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ResultStatCard(
                        title: "chunksRead".localized,
                        value: "\(chunksRead)",
                        icon: "rectangle.3.group",
                        color: .green
                    )

                    ResultStatCard(
                        title: "wordsRead".localized,
                        value: "\(wordsRead)",
                        icon: "text.word.spacing",
                        color: .blue
                    )

                    ResultStatCard(
                        title: "chunkSize".localized,
                        value: "\(chunkSize) words",
                        icon: "square.split.2x1",
                        color: .purple
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
                        color: .orange
                    )
                }
                .padding(.horizontal)

                // Motivational Message
                Text(motivationalMessage)
                    .font(.system(size: DesignSystem.Typography.body))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.large)

                // Next Steps
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    HStack(spacing: DesignSystem.Spacing.small) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(DesignSystem.Colors.primary)
                        Text("nextSteps".localized)
                            .font(.system(size: DesignSystem.Typography.body, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                    }

                    Text(nextStepsMessage)
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .cardStyle()
                .padding(.horizontal)

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

    private var speedColor: Color {
        let category = WPMCalculator.speedCategory(wpm: averageWPM)
        switch category {
        case .slow: return .orange
        case .average: return .blue
        case .good: return .green
        case .excellent, .exceptional: return .purple
        }
    }

    private var motivationalMessage: String {
        let category = WPMCalculator.speedCategory(wpm: averageWPM)

        switch category {
        case .exceptional:
            return "Outstanding! Your chunking skills are exceptional. You're reading like a pro!"
        case .excellent:
            return "Excellent work! Your ability to process word groups is highly developed."
        case .good:
            return "Great job! You're making solid progress with chunking technique."
        case .average:
            return "Good effort! Keep practicing to improve your chunking efficiency."
        case .slow:
            return "You're on the right track! Regular practice will help you read chunks more naturally."
        }
    }

    private var nextStepsMessage: String {
        if chunkSize < 5 {
            return "Try increasing your chunk size to \(chunkSize + 1) words for an additional challenge. Larger chunks will further expand your reading span."
        } else {
            return "You're reading maximum size chunks! Try increasing the speed or duration to continue challenging yourself."
        }
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

#Preview {
    NavigationView {
        ChunkingResultsView(
            chunksRead: 150,
            chunkSize: 3,
            timeSpent: 300
        )
    }
}
