//
//  ChunkingSettingsView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ChunkingSettingsView: View {
    @State private var chunkSize: Int = 3
    @State private var speed: ChunkingSpeed = .medium
    @State private var duration: Int = 10
    @State private var navigateToTraining = false

    @Environment(\.dismiss) var dismiss

    enum ChunkingSpeed: String, CaseIterable {
        case slow, medium, fast, veryFast

        var displayName: String {
            switch self {
            case .slow: return "speedSlow".localized
            case .medium: return "speedMedium".localized
            case .fast: return "speedFast".localized
            case .veryFast: return "speedVeryFast".localized
            }
        }

        var interval: TimeInterval {
            switch self {
            case .slow: return 2.0
            case .medium: return 1.5
            case .fast: return 1.0
            case .veryFast: return 0.7
            }
        }

        var color: Color {
            switch self {
            case .slow: return .green
            case .medium: return .blue
            case .fast: return .orange
            case .veryFast: return .red
            }
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.extraLarge) {
                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("chunking".localized)
                            .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        Text("chunking subtitle".localized)
                            .font(.system(size: DesignSystem.Typography.body))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }

                    // Chunk Size Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("chunk size".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        HStack(spacing: DesignSystem.Spacing.small) {
                            ForEach([2, 3, 4, 5], id: \.self) { size in
                                ChunkSizeButton(size: size, isSelected: chunkSize == size) {
                                    chunkSize = size
                                }
                            }
                        }
                    }

                    // Speed Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        Text("highlightSpeed".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        VStack(spacing: DesignSystem.Spacing.small) {
                            ForEach(ChunkingSpeed.allCases, id: \.self) { speedOption in
                                SpeedCard(
                                    speed: speedOption,
                                    isSelected: speed == speedOption
                                ) {
                                    speed = speedOption
                                }
                            }
                        }
                    }

                    // Duration Setting
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("sessionLength".localized)
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))

                        HStack(spacing: DesignSystem.Spacing.small) {
                            DurationButton(duration: 5, isSelected: duration == 5) {
                                duration = 5
                            }
                            DurationButton(duration: 10, isSelected: duration == 10) {
                                duration = 10
                            }
                            DurationButton(duration: 15, isSelected: duration == 15) {
                                duration = 15
                            }
                        }
                    }

                    // Info Box
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack(spacing: DesignSystem.Spacing.small) {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(DesignSystem.Colors.primary)
                            Text("chunking how to".localized)
                                .font(.system(size: DesignSystem.Typography.body, weight: .semibold))
                                .foregroundColor(DesignSystem.Colors.textPrimary)
                        }

                        Text("chunking instructions".localized)
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
            .navigationTitle("trainingChunkingName".localized)
            .navigationBarTitleDisplayMode(.inline)

            // Hidden NavigationLink (iOS 15 compatible)
            NavigationLink(
                destination: ChunkingTrainingView(
                    chunkSize: chunkSize,
                    speed: speed,
                    duration: duration
                ),
                isActive: $navigateToTraining
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
}

// MARK: - Chunk Size Button
struct ChunkSizeButton: View {
    let size: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(size)")
                    .font(.system(size: DesignSystem.Typography.title1, weight: .bold))
                Text("words".localized)
                    .font(.system(size: DesignSystem.Typography.caption))
            }
            .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
            .cornerRadius(DesignSystem.CornerRadius.medium)
        }
    }
}

// MARK: - Speed Card
struct SpeedCard: View {
    let speed: ChunkingSettingsView.ChunkingSpeed
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                Circle()
                    .fill(speed.color)
                    .frame(width: 12, height: 12)

                Text(speed.displayName)
                    .font(.system(size: DesignSystem.Typography.body, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Text(String(format: "%.1fs", speed.interval))
                    .font(.system(size: DesignSystem.Typography.caption))
                    .foregroundColor(DesignSystem.Colors.textSecondary)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
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
        }
    }
}

#Preview {
    NavigationView {
        ChunkingSettingsView()
    }
}
