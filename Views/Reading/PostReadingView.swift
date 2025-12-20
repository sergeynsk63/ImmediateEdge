//
//  PostReadingView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct PostReadingView: View {
    let text: TextContent
    let readingTime: Int

    @State private var navigateToTest = false
    @Environment(\.dismiss) var dismiss

    private var wpm: Int {
        guard readingTime > 0 else { return 0 }
        let minutes = Double(readingTime) / 60.0
        return Int(Double(text.wordCount) / minutes)
    }

    var body: some View {
        ZStack {
            VStack(spacing: DesignSystem.Spacing.extraLarge) {
                Spacer()

                // Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(DesignSystem.Colors.success)

                // Title
                VStack(spacing: 8) {
                    Text("readingCompleteTitle".localized)
                        .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))

                    Text(String(format: "readingSummaryFormat".localized, text.wordCount, formatTime(readingTime)))
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                // Stats Card
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ResultStatCard(
                        title: "readingSpeedLabel".localized,
                        value: "\(wpm) WPM",
                        icon: "speedometer",
                        color: speedColor
                    )

                    ResultStatCard(
                        title: "readingTimeLabel".localized,
                        value: formatTime(readingTime),
                        icon: "clock.fill",
                        color: .blue
                    )
                }
                .padding(.horizontal)

                // Test Prompt
                VStack(spacing: DesignSystem.Spacing.medium) {
                    Text("readingTestPrompt".localized)
                        .font(.system(size: DesignSystem.Typography.headline))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    PrimaryButton(title: "buttonTakeComprehensionTest".localized) {
                        navigateToTest = true
                    }

                    SecondaryButton(title: "skip".localized) {
                        dismiss()
                    }
                }
                .padding(.horizontal)

                Spacer()
            }

            // Hidden NavigationLink
            NavigationLink(
                destination: ComprehensionTestView(
                    questions: text.questions,
                    onComplete: { answers in
                        // Save results and dismiss
                        dismiss()
                    }
                ),
                isActive: $navigateToTest
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarBackButtonHidden(true)
    }

    private var speedColor: Color {
        let category = WPMCalculator.speedCategory(wpm: wpm)
        switch category {
        case .slow: return .orange
        case .average: return .blue
        case .good: return .green
        case .excellent, .exceptional: return .purple
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        if mins > 0 {
            return "\(mins)m \(secs)s"
        }
        return "\(secs)s"
    }
}

#Preview {
    NavigationView {
        PostReadingView(text: TextLibraryData.allTexts[0], readingTime: 120)
    }
}
