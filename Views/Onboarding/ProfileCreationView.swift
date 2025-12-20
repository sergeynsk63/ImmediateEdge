//
//  ProfileCreationView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ProfileCreationView: View {
    let initialWPM: Int

    @State private var username: String = ""
    @State private var selectedGoal: ReadingGoal = .both
    @State private var selectedDifficulty: Difficulty = .intermediate
    @State private var selectedInterests: Set<Interest> = []
    @State private var isCompleting = false

    @Environment(\.dismiss) var dismiss

    enum ReadingGoal: String, CaseIterable {
        case speed
        case comprehension
        case both

        var displayName: String {
            switch self {
            case .speed: return "profileGoalSpeed".localized
            case .comprehension: return "profileGoalComprehension".localized
            case .both: return "profileGoalBoth".localized
            }
        }

        var icon: String {
            switch self {
            case .speed: return "bolt.fill"
            case .comprehension: return "brain.head.profile"
            case .both: return "star.fill"
            }
        }
    }

    enum Interest: String, CaseIterable {
        case business
        case science
        case history
        case psychology
        case literature
        case technology

        var displayName: String {
            switch self {
            case .business: return "Business"
            case .science: return "Science"
            case .history: return "History"
            case .psychology: return "Psychology"
            case .literature: return "Literature"
            case .technology: return "Technology"
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraLarge) {
                // Header
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("profileCreationTitle".localized)
                        .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text("Let's personalize your experience")
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                // Username
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("profileUsernameLabel".localized)
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    TextField("profileUsernamePlaceholder".localized, text: $username)
                        .textFieldStyle(CustomTextFieldStyle())
                }

                // Reading Goal
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("profileGoalLabel".localized)
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    HStack(spacing: DesignSystem.Spacing.small) {
                        ForEach(ReadingGoal.allCases, id: \.self) { goal in
                            GoalButton(
                                goal: goal,
                                isSelected: selectedGoal == goal
                            ) {
                                selectedGoal = goal
                            }
                        }
                    }
                }

                // Difficulty
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("profileDifficultyLabel".localized)
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    HStack(spacing: DesignSystem.Spacing.small) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            DifficultyButton(
                                difficulty: difficulty,
                                isSelected: selectedDifficulty == difficulty
                            ) {
                                selectedDifficulty = difficulty
                            }
                        }
                    }
                }

                // Interests
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text("profileInterestsLabel".localized)
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text("Select topics you're interested in")
                        .font(.system(size: DesignSystem.Typography.subhead))
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    // Simple grid layout for interests
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack(spacing: DesignSystem.Spacing.small) {
                            InterestChip(interest: .business, isSelected: selectedInterests.contains(.business)) {
                                toggleInterest(.business)
                            }
                            InterestChip(interest: .science, isSelected: selectedInterests.contains(.science)) {
                                toggleInterest(.science)
                            }
                            InterestChip(interest: .history, isSelected: selectedInterests.contains(.history)) {
                                toggleInterest(.history)
                            }
                        }
                        HStack(spacing: DesignSystem.Spacing.small) {
                            InterestChip(interest: .psychology, isSelected: selectedInterests.contains(.psychology)) {
                                toggleInterest(.psychology)
                            }
                            InterestChip(interest: .literature, isSelected: selectedInterests.contains(.literature)) {
                                toggleInterest(.literature)
                            }
                            InterestChip(interest: .technology, isSelected: selectedInterests.contains(.technology)) {
                                toggleInterest(.technology)
                            }
                        }
                    }
                }

                // Complete Button
                PrimaryButton(
                    title: "buttonCompleteSetup".localized,
                    action: completeSetup
                )
                .disabled(isCompleting)

                Spacer()
                    .frame(height: 20)
            }
            .padding(DesignSystem.Spacing.large)
        }
        .navigationBarBackButtonHidden(true)
    }

    private func completeSetup() {
        isCompleting = true

        // Create user profile (language removed - will use device locale automatically)
        let profile = UserProfile(
            username: username.isEmpty ? "Reader" : username,
            language: Locale.current.languageCode ?? "en",
            preferences: UserPreferences(preferredDifficulty: selectedDifficulty)
        )

        // Save to Core Data
        DataManager.shared.createUserProfile(profile)

        // Save initial stats
        UserDefaults.standard.hasCompletedOnboarding = true
        UserDefaults.standard.currentUserId = profile.id.uuidString

        // Navigate to main app
        // This will be handled by the root view observing UserDefaults
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isCompleting = false
        }
    }

    private func toggleInterest(_ interest: Interest) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
}

// MARK: - Goal Button
struct GoalButton: View {
    let goal: ProfileCreationView.ReadingGoal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.Spacing.small) {
                Image(systemName: goal.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : DesignSystem.Colors.primary)

                Text(goal.displayName)
                    .font(.system(size: DesignSystem.Typography.caption, weight: .medium))
                    .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.medium)
            .background(
                isSelected ?
                    DesignSystem.Colors.primary :
                    DesignSystem.Colors.secondaryBackground
            )
            .cornerRadius(DesignSystem.CornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Difficulty Button
struct DifficultyButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue.capitalized)
                .font(.system(size: DesignSystem.Typography.body, weight: .medium))
                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignSystem.Spacing.medium)
                .background(
                    isSelected ?
                        DesignSystem.Colors.primary :
                        DesignSystem.Colors.secondaryBackground
                )
                .cornerRadius(DesignSystem.CornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Interest Chip
struct InterestChip: View {
    let interest: ProfileCreationView.Interest
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                }

                Text(interest.displayName)
                    .font(.system(size: DesignSystem.Typography.subhead, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(DesignSystem.Colors.secondaryBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
    }
}

#Preview {
    NavigationView {
        ProfileCreationView(initialWPM: 250)
    }
}
