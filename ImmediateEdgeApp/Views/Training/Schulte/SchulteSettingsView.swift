//
//  SchulteSettingsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct SchulteSettingsView: View {
    @State private var difficulty: SchulteDifficulty = .easy
    @State private var rounds: Int = 3
    @State private var navigateToTraining = false

    @Environment(\.dismiss) var dismiss

    enum SchulteDifficulty: String, CaseIterable {
        case easy, medium, hard

        var displayName: String {
            switch self {
            case .easy: return "difficultyEasy".localized
            case .medium: return "difficultyMedium".localized
            case .hard: return "difficultyHard".localized
            }
        }

        var description: String {
            switch self {
            case .easy: return "5×5 grid (1-25)"
            case .medium: return "7×7 grid (1-49)"
            case .hard: return "Mixed numbers/letters"
            }
        }

        var gridSize: Int {
            switch self {
            case .easy: return 5
            case .medium: return 7
            case .hard: return 5
            }
        }

        var icon: String {
            switch self {
            case .easy: return "square.grid.3x3"
            case .medium: return "square.grid.4x4"
            case .hard: return "square.grid.3x3.topleft.filled"
            }
        }

        var color: Color {
            switch self {
            case .easy: return .green
            case .medium: return .orange
            case .hard: return .red
            }
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraLarge) {
                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("schulte".localized)
                            .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        Text("schulte subtitle".localized)
                            .font(.system(size: DesignSystem.Typography.body))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }

                    // Difficulty Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("difficultyTitle".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        ForEach(SchulteDifficulty.allCases, id: \.self) { level in
                            DifficultyCard(
                                difficulty: level,
                                isSelected: difficulty == level
                            ) {
                                difficulty = level
                            }
                        }
                    }

                    // Rounds Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("rounds".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        HStack(spacing: DesignSystem.Spacing.small) {
                            RoundsButton(rounds: 1, isSelected: rounds == 1) {
                                rounds = 1
                            }
                            RoundsButton(rounds: 3, isSelected: rounds == 3) {
                                rounds = 3
                            }
                            RoundsButton(rounds: 5, isSelected: rounds == 5) {
                                rounds = 5
                            }
                        }
                    }

                    // Info Box
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack(spacing: DesignSystem.Spacing.small) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(DesignSystem.Colors.primary)
                            Text("how to".localized)
                                .font(.system(size: DesignSystem.Typography.body, weight: .semibold))
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }

                        Text("schulte instructions".localized)
                            .font(.system(size: DesignSystem.Typography.body))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .cardStyle()

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
            .navigationTitle("trainingSchulteName".localized)
            .navigationBarTitleDisplayMode(.inline)

            // Hidden NavigationLink (iOS 15 compatible)
            NavigationLink(
                destination: SchulteTrainingView(
                    difficulty: difficulty,
                    rounds: rounds
                ),
                isActive: $navigateToTraining
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
}

// MARK: - Difficulty Card
struct DifficultyCard: View {
    let difficulty: SchulteSettingsView.SchulteDifficulty
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                // Icon
                ZStack {
                    Circle()
                        .fill(difficulty.color.opacity(isSelected ? 0.3 : 0.1))
                        .frame(width: 50, height: 50)

                    Image(systemName: difficulty.icon)
                        .font(.system(size: 24))
                        .foregroundColor(difficulty.color)
                }

                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.displayName)
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text(difficulty.description)
                        .font(.system(size: DesignSystem.Typography.subhead))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(DesignSystem.Colors.primary)
                }
            }
            .padding()
            .background(
                isSelected ?
                    DesignSystem.Colors.primary.opacity(0.1) :
                    DesignSystem.Colors.secondaryBackground
            )
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(
                        isSelected ? DesignSystem.Colors.primary : Color.clear,
                        lineWidth: 2
                    )
            )
        }
    }
}

// MARK: - Rounds Button
struct RoundsButton: View {
    let rounds: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(rounds)")
                    .font(.system(size: DesignSystem.Typography.title1, weight: .bold))
                Text(rounds == 1 ? "round" : "rounds")
                    .font(.system(size: DesignSystem.Typography.caption))
            }
            .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
        }
    }
}

#Preview {
    NavigationView {
        SchulteSettingsView()
    }
}
