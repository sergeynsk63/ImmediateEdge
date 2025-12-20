//
//  ComprehensionTestView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ComprehensionTestView: View {
    let questions: [Question]
    let onComplete: ([Int]) -> Void

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int?]
    @State private var showResults = false

    init(questions: [Question], onComplete: @escaping ([Int]) -> Void) {
        self.questions = questions
        self.onComplete = onComplete
        _selectedAnswers = State(initialValue: Array(repeating: nil, count: questions.count))
    }

    var currentQuestion: Question {
        questions[currentQuestionIndex]
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == questions.count - 1
    }

    var canProceed: Bool {
        selectedAnswers[currentQuestionIndex] != nil
    }

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // Progress
            SwiftUI.ProgressView(value: Double(currentQuestionIndex + 1) / Double(questions.count))
                .tint(DesignSystem.Colors.primary)

            Text("Question \(currentQuestionIndex + 1) of \(questions.count)")
                .font(.system(size: DesignSystem.Typography.subhead))
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Spacer()

            // Question
            Text(currentQuestion.question)
                .font(.system(size: DesignSystem.Typography.title2, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // Options
            VStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                    OptionButton(
                        text: currentQuestion.options[index],
                        isSelected: selectedAnswers[currentQuestionIndex] == index
                    ) {
                        selectedAnswers[currentQuestionIndex] = index
                    }
                }
            }

            Spacer()

            // Navigation
            HStack(spacing: DesignSystem.Spacing.medium) {
                if currentQuestionIndex > 0 {
                    SecondaryButton(title: "back".localized) {
                        currentQuestionIndex -= 1
                    }
                }

                PrimaryButton(
                    title: isLastQuestion ? "done".localized : "next".localized,
                    action: {
                        if isLastQuestion {
                            completeTest()
                        } else {
                            currentQuestionIndex += 1
                        }
                    },
                    isEnabled: canProceed
                )
            }
        }
        .padding()
        .navigationTitle("Comprehension Test")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func completeTest() {
        let answers = selectedAnswers.compactMap { $0 }
        onComplete(answers)
    }
}

struct OptionButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: DesignSystem.Typography.body))
                    .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationView {
        ComprehensionTestView(
            questions: [
                Question(
                    question: "What is the main topic of the text?",
                    options: ["Speed Reading", "History", "Science", "Art"],
                    correctAnswerIndex: 0,
                    type: .mainIdea
                ),
                Question(
                    question: "How many techniques were mentioned?",
                    options: ["Two", "Three", "Four", "Five"],
                    correctAnswerIndex: 1,
                    type: .details
                )
            ],
            onComplete: { answers in
                print("Answers: \(answers)")
            }
        )
    }
}
