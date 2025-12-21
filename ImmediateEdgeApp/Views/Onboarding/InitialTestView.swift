//
//  InitialTestView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct InitialTestView: View {
    @State private var testPhase: TestPhase = .instructions
    @State private var startTime: Date?
    @State private var endTime: Date?
    @State private var userAnswers: [Int] = []
    @State private var navigateToResults = false
    @State private var navigateToProfile = false

    enum TestPhase {
        case instructions
        case reading
        case comprehension
        case results
    }

    var body: some View {
        ZStack {
            Group {
                switch testPhase {
                case .instructions:
                    InstructionsView {
                        testPhase = .reading
                        startTime = Date()
                    }

                case .reading:
                    ReadingTestView {
                        endTime = Date()
                        testPhase = .comprehension
                    }

                case .comprehension:
                    ComprehensionTestView(
                        questions: sampleQuestions,
                        onComplete: { answers in
                            userAnswers = answers
                            testPhase = .results
                        }
                    )

                case .results:
                    TestResultsView(
                        wpm: calculatedWPM,
                        comprehension: calculatedComprehension,
                        onContinue: {
                            navigateToProfile = true
                        }
                    )
                }
            }
            .navigationBarBackButtonHidden(testPhase != .instructions)

            // Hidden NavigationLink for programmatic navigation (iOS 15 compatible)
            NavigationLink(
                destination: ProfileCreationView(initialWPM: calculatedWPM),
                isActive: $navigateToProfile
            ) {
                EmptyView()
            }
            .hidden()
        }
    }

    private var calculatedWPM: Int {
        guard let start = startTime, let end = endTime else { return 0 }
        let timeInSeconds = Int(end.timeIntervalSince(start))
        return WPMCalculator.calculate(wordsRead: sampleText.wordCount, timeInSeconds: timeInSeconds)
    }

    private var calculatedComprehension: Float {
        let correctAnswers = userAnswers.enumerated().filter { index, answer in
            answer == sampleQuestions[index].correctAnswerIndex
        }.count
        return Float(correctAnswers) / Float(sampleQuestions.count)
    }
}

// MARK: - Instructions View
struct InstructionsView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.extraLarge) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(DesignSystem.Colors.primary.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: "book.pages")
                    .font(.system(size: 60))
                    .foregroundColor(DesignSystem.Colors.primary)
            }

            // Instructions
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text("buttonTestSpeed".localized)
                    .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    InstructionItem(
                        icon: "book.fill",
                        text: "initialTestInstructions".localized
                    )

                    InstructionItem(
                        icon: "questionmark.circle.fill",
                        text: "initialTestInstructionsDetail".localized
                    )

                    InstructionItem(
                        icon: "clock.fill",
                        text: "Read at your natural comfortable pace"
                    )
                }
                .padding(.horizontal, DesignSystem.Spacing.large)
            }

            Spacer()

            // Start Button
            PrimaryButton(title: "start".localized, action: onStart)
                .padding(.horizontal, DesignSystem.Spacing.large)

            Spacer()
                .frame(height: 20)
        }
        .padding()
        .navigationTitle("Initial Test")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InstructionItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(DesignSystem.Colors.primary)
                .frame(width: 24)

            Text(text)
                .font(.system(size: DesignSystem.Typography.body))
                .foregroundColor(DesignSystem.Colors.textPrimary)
        }
    }
}

// MARK: - Reading Test View
struct ReadingTestView: View {
    let onComplete: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                Text(sampleText)
                    .font(.system(size: DesignSystem.Typography.readingMedium))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .lineSpacing(8)

                Spacer()
                    .frame(height: 40)

                PrimaryButton(title: "buttonFinishReading".localized, action: onComplete)
            }
            .padding(DesignSystem.Spacing.large)
        }
        .navigationTitle("Read the Text")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Test Results View
struct TestResultsView: View {
    let wpm: Int
    let comprehension: Float
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.extraLarge) {
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(DesignSystem.Colors.success)

                // Title
                Text("Test Complete!")
                    .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))

                // Results Cards
                VStack(spacing: DesignSystem.Spacing.medium) {
                    ResultCard(
                        title: "Reading Speed",
                        value: "\(wpm)",
                        icon: "speedometer",
                        color: speedColor
                    )

                    ResultCard(
                        title: "Comprehension",
                        value: comprehension.percentageString,
                        icon: "brain.head.profile",
                        color: comprehensionColor
                    )
                }

                // Motivational Message
                Text(motivationalMessage)
                    .font(.system(size: DesignSystem.Typography.body))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.large)

                Spacer()
                    .frame(height: 20)

                // Continue Button
                PrimaryButton(title: "continue".localized, action: onContinue)
                    .padding(.horizontal, DesignSystem.Spacing.large)
            }
            .padding()
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

    private var comprehensionColor: Color {
        switch comprehension {
        case 0.9...1.0: return .green
        case 0.8..<0.9: return .blue
        case 0.7..<0.8: return .orange
        default: return .red
        }
    }

    private var motivationalMessage: String {
        let category = WPMCalculator.speedCategory(wpm: wpm)
        return category.description + " Let's improve together!"
    }
}

// MARK: - Sample Data
private let sampleText = """
Speed reading is a collection of methods for increasing reading speed without an unacceptable reduction in comprehension. The methods include chunking and minimizing subvocalization. The many available speed reading training programs include books, videos, software, and seminars.

The ability to read rapidly is fundamental to succeeding in modern society. In academic environments, individuals must process vast amounts of information. In professional contexts, reading skills directly impact productivity and efficiency. The average person reads between 200 and 250 words per minute, but with training, many people can double or even triple their reading speed while maintaining good comprehension.

Speed reading techniques have been researched and developed for over a century. The methods focus on training the eyes to move more efficiently across text, reducing subvocalization (the habit of silently pronouncing words while reading), and improving visual processing. These techniques can help readers absorb more information in less time.

One of the most effective techniques is called "chunking," which involves training your eyes to read groups of words together rather than individual words. This method leverages your brain's ability to recognize patterns and process multiple pieces of information simultaneously. By expanding your visual span, you can take in more words with each fixation, significantly increasing your reading speed.

Another important aspect of speed reading is improving comprehension through active reading strategies. This includes previewing material before reading, identifying key ideas, and regularly reviewing what you've read. These metacognitive strategies help ensure that increased speed doesn't come at the expense of understanding.
"""

private let sampleQuestions = [
    Question(
        question: "What is the average reading speed for most people?",
        options: ["100-150 WPM", "200-250 WPM", "300-350 WPM", "400-450 WPM"],
        correctAnswerIndex: 1,
        type: .details
    ),
    Question(
        question: "What is 'chunking' in speed reading?",
        options: [
            "Reading individual letters",
            "Reading groups of words together",
            "Skipping words",
            "Reading backwards"
        ],
        correctAnswerIndex: 1,
        type: .details
    ),
    Question(
        question: "What does subvocalization mean?",
        options: [
            "Reading out loud",
            "Reading too fast",
            "Silently pronouncing words while reading",
            "Skipping sentences"
        ],
        correctAnswerIndex: 2,
        type: .vocabulary
    ),
    Question(
        question: "How long have speed reading techniques been researched?",
        options: [
            "Less than 50 years",
            "About 75 years",
            "Over a century",
            "More than 200 years"
        ],
        correctAnswerIndex: 2,
        type: .details
    ),
    Question(
        question: "What is the main idea of this text?",
        options: [
            "Speed reading is impossible to learn",
            "Speed reading methods can help people read faster while maintaining comprehension",
            "Reading slowly is always better",
            "Comprehension is not important"
        ],
        correctAnswerIndex: 1,
        type: .mainIdea
    )
]

#Preview {
    NavigationView {
        InitialTestView()
    }
}
