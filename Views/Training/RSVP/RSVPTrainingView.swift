//
//  RSVPTrainingView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct RSVPTrainingView: View {
    let speed: Double // WPM
    let duration: Int // minutes
    let wordsPerDisplay: Int
    let fontSize: CGFloat

    @State private var currentIndex = 0
    @State private var isPaused = false
    @State private var showPauseMenu = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var wordTimer: Timer?
    @State private var navigateToTest = false

    @Environment(\.dismiss) var dismiss

    // Sample training text
    private let trainingText = """
    The digital age has transformed how we process information. With the constant flow of emails, articles, and reports, the ability to read quickly and efficiently has become more valuable than ever. Speed reading techniques can help you absorb more information in less time while maintaining comprehension.

    One of the most effective methods is Rapid Serial Visual Presentation, or RSVP. This technique displays words or small groups of words in rapid succession at a fixed point on the screen. By eliminating the need for eye movements, RSVP allows your brain to focus entirely on processing the information.

    Research shows that with practice, people can double or even triple their reading speed using RSVP while maintaining good comprehension levels. The key is to start at a comfortable pace and gradually increase the speed as you become more proficient. Regular practice is essential for developing this skill.

    Modern applications of RSVP extend beyond just reading text. The technique is used in various fields, from education to professional training, helping people process large volumes of information more efficiently. As our information-rich world continues to evolve, mastering speed reading techniques like RSVP becomes increasingly important.
    """

    private var words: [String] {
        trainingText.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
    }

    private var totalWords: Int {
        words.count
    }

    private var wordsRead: Int {
        min(currentIndex, totalWords)
    }

    private var progress: Double {
        totalWords > 0 ? Double(wordsRead) / Double(totalWords) : 0
    }

    private var displayText: String {
        guard currentIndex < words.count else { return "" }

        let endIndex = min(currentIndex + wordsPerDisplay, words.count)
        return words[currentIndex..<endIndex].joined(separator: " ")
    }

    private var intervalBetweenWords: TimeInterval {
        // Convert WPM to seconds per word group
        60.0 / (speed / Double(wordsPerDisplay))
    }

    var body: some View {
        ZStack {
            // Main Training Area
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        stopTraining()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    // Timer
                    Text(formatTime(elapsedTime))
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Spacer()

                    Button(action: {
                        togglePause()
                    }) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.primary)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer()

                // Word Display Area
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Word counter
                    Text("\(wordsRead) / \(totalWords)")
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    // Current word(s)
                    Text(displayText)
                        .font(.system(size: fontSize, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .minimumScaleFactor(0.5)
                        .lineLimit(wordsPerDisplay > 1 ? 2 : 1)
                }

                Spacer()

                // Progress Bar
                VStack(spacing: DesignSystem.Spacing.small) {
                    SwiftUI.ProgressView(value: progress)
                        .tint(DesignSystem.Colors.primary)

                    Text(String(format: "%.0f%%", progress * 100))
                        .font(.system(size: DesignSystem.Typography.caption))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding()
            }

            // Pause Menu Overlay
            if showPauseMenu {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPauseMenu = false
                    }

                PauseMenuView(
                    currentSpeed: speed,
                    onResume: {
                        showPauseMenu = false
                        togglePause()
                    },
                    onAdjustSpeed: { newSpeed in
                        // TODO: Implement speed adjustment
                        showPauseMenu = false
                        togglePause()
                    },
                    onExit: {
                        stopTraining()
                        dismiss()
                    }
                )
            }

            // Hidden NavigationLink for results
            NavigationLink(
                destination: RSVPResultsView(
                    wordsRead: wordsRead,
                    averageWPM: Int(speed),
                    timeSpent: Int(elapsedTime),
                    comprehensionScore: nil
                ),
                isActive: $navigateToTest
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarHidden(true)
        .onAppear {
            startTraining()
        }
        .onDisappear {
            stopTraining()
        }
    }

    private func startTraining() {
        // Start elapsed time timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !isPaused {
                elapsedTime += 1

                // Check if duration is reached
                if Int(elapsedTime) >= duration * 60 {
                    completeTraining()
                }
            }
        }

        // Start word display timer
        startWordTimer()
    }

    private func startWordTimer() {
        wordTimer = Timer.scheduledTimer(withTimeInterval: intervalBetweenWords, repeats: true) { _ in
            if !isPaused {
                if currentIndex < totalWords {
                    currentIndex += wordsPerDisplay
                } else {
                    completeTraining()
                }
            }
        }
    }

    private func stopTraining() {
        timer?.invalidate()
        wordTimer?.invalidate()
        timer = nil
        wordTimer = nil
    }

    private func togglePause() {
        isPaused.toggle()
        if isPaused {
            showPauseMenu = true
        }
    }

    private func completeTraining() {
        stopTraining()
        navigateToTest = true
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Pause Menu
struct PauseMenuView: View {
    let currentSpeed: Double
    let onResume: () -> Void
    let onAdjustSpeed: (Double) -> Void
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Text("trainingPaused".localized)
                .font(.system(size: DesignSystem.Typography.title1, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            VStack(spacing: DesignSystem.Spacing.medium) {
                PrimaryButton(
                    title: "resume".localized,
                    action: onResume
                )

                SecondaryButton(
                    title: "exit".localized,
                    action: onExit
                )
            }
        }
        .padding(DesignSystem.Spacing.extraLarge)
        .background(DesignSystem.Colors.background)
        .cornerRadius(DesignSystem.CornerRadius.large)
        .shadow(radius: 20)
        .padding(DesignSystem.Spacing.large)
    }
}

#Preview {
    NavigationView {
        RSVPTrainingView(speed: 250, duration: 5, wordsPerDisplay: 1, fontSize: 48)
    }
}
