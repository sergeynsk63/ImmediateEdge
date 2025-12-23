//
//  TrainingSelectionView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct TrainingSelectionView: View {
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        ExerciseCard(
                            name: "trainingRSVPName".localized,
                            description: "trainingRSVPDescription".localized,
                            icon: "bolt.fill",
                            color: DesignSystem.Colors.rsvpColor,
                            estimatedTime: "5-10",
                            destination: AnyView(RSVPSettingsView())
                        )

                        ExerciseCard(
                            name: "trainingSchulteName".localized,
                            description: "trainingSchulteDescription".localized,
                            icon: "eye.fill",
                            color: DesignSystem.Colors.schulteColor,
                            estimatedTime: "3-5",
                            destination: AnyView(SchulteSettingsView())
                        )

                        ExerciseCard(
                            name: "trainingChunkingName".localized,
                            description: "trainingChunkingDescription".localized,
                            icon: "square.stack.3d.up.fill",
                            color: DesignSystem.Colors.chunkingColor,
                            estimatedTime: "5-10",
                            destination: AnyView(ChunkingSettingsView())
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("trainingSelectionTitle".localized)
        }
        .navigationViewStyle(.stack)
    }
}

struct ExerciseCard: View {
    let name: String
    let description: String
    let icon: String
    let color: Color
    let estimatedTime: String
    let destination: AnyView

    init(name: String, description: String, icon: String, color: Color, estimatedTime: String, destination: AnyView) {
        self.name = name
        self.description = description
        self.icon = icon
        self.color = color
        self.estimatedTime = estimatedTime
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                // Icon with solid background
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color)
                        .frame(width: 64, height: 64)
                        .shadow(color: color.opacity(0.3), radius: 8, y: 4)

                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }

                // Content
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.system(size: DesignSystem.Typography.headline, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Text(description)
                        .font(.system(size: DesignSystem.Typography.subhead))
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                        .lineLimit(2)

                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                        Text(estimatedTime + " min")
                            .font(.system(size: DesignSystem.Typography.caption, weight: .medium))
                    }
                    .foregroundColor(color)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding(DesignSystem.Spacing.medium)
            .background(DesignSystem.Colors.cardBackground)
            .cornerRadius(DesignSystem.CornerRadius.large)
            .shadow(
                color: Color.black.opacity(0.05),
                radius: 8,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    TrainingSelectionView()
}
