//
//  DashboardView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedTab: Int?

    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        } else {
                            // Welcome Message
                            if viewModel.hasData {
                                WelcomeMessageView(
                                    message: viewModel.welcomeMessage,
                                    trendMessage: viewModel.progressTrend.message
                                )
                            }

                            // Statistics Card
                            StatisticsCardView(
                                wpm: viewModel.currentWPM,
                                comprehension: viewModel.comprehensionPercentage,
                                streak: viewModel.currentStreak,
                                streakEmoji: viewModel.streakEmoji,
                                totalSessions: viewModel.totalSessions
                            )

                            // Quick Actions
                            QuickActionsView(selectedTab: $selectedTab)

                            // Progress Overview
                            if viewModel.hasData {
                                ProgressOverviewView(
                                    recentProgress: viewModel.recentProgress,
                                    trend: viewModel.progressTrend
                                )
                            } else {
                                EmptyStateView()
                            }

                            // Motivational Quote
                            MotivationalQuoteView(quote: viewModel.motivationalQuote)

                            Spacer()
                        }
                    }
                    .padding()
                }
                .navigationTitle("homeTitle".localized)
                .refreshable {
                    viewModel.refreshData()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Welcome Message
struct WelcomeMessageView: View {
    let message: String
    let trendMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(message)
                .font(.system(size: DesignSystem.Typography.title2, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text(trendMessage)
                .font(.system(size: DesignSystem.Typography.subhead))
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Statistics Card
struct StatisticsCardView: View {
    let wpm: Int
    let comprehension: String
    let streak: Int
    let streakEmoji: String
    let totalSessions: Int

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            // Current WPM
            VStack(spacing: DesignSystem.Spacing.extraSmall) {
                Text("\(wpm)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.primary)
                Text("wordsPerMinute".localized)
                    .font(.system(size: DesignSystem.Typography.footnote))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }

            Divider()

            // Stats Row
            HStack(spacing: DesignSystem.Spacing.large) {
                StatItemView(
                    title: "comprehensionLabel".localized,
                    value: comprehension,
                    icon: "brain.head.profile"
                )

                Divider()
                    .frame(height: 40)

                StatItemView(
                    title: "streakLabel".localized,
                    value: "\(streakEmoji) \(streak)",
                    icon: "flame.fill"
                )

                Divider()
                    .frame(height: 40)

                StatItemView(
                    title: "totalSessionsLabel".localized,
                    value: "\(totalSessions)",
                    icon: "list.bullet"
                )
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .cardStyle()
    }
}

struct StatItemView: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.extraSmall) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(DesignSystem.Colors.secondary)

            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text(title)
                .font(.system(size: DesignSystem.Typography.caption))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Quick Actions
struct QuickActionsView: View {
    @Binding var selectedTab: Int?

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            PrimaryButton(title: "buttonStartTraining".localized) {
                selectedTab = 1 // Training tab
            }

            HStack(spacing: DesignSystem.Spacing.medium) {
                SecondaryButton(title: "buttonPracticeReading".localized) {
                    selectedTab = 3 // Library tab
                }

                SecondaryButton(title: "buttonTestSpeed".localized) {
                    // Navigate to test
                }
            }
        }
    }
}

// MARK: - Progress Overview
struct ProgressOverviewView: View {
    let recentProgress: [SessionSummary]
    let trend: ProgressTrend

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            HStack {
                Text("statisticsSpeedGrowthLabel".localized)
                    .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: trend.icon)
                        .font(.system(size: 12))
                    Text("Last 7 days")
                        .font(.system(size: DesignSystem.Typography.caption))
                }
                .foregroundColor(trend.color)
            }

            // Mini Line Chart
            MiniLineChartView(data: recentProgress.compactMap { $0.wpm })

            Button(action: {
                // Navigate to detailed stats
            }) {
                Text("buttonViewAnalytics".localized)
                    .font(.system(size: DesignSystem.Typography.subhead))
                    .foregroundColor(DesignSystem.Colors.primary)
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .cardStyle()
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            Image(systemName: "book.pages")
                .font(.system(size: 60))
                .foregroundColor(DesignSystem.Colors.textSecondary)

            Text("Start your first training session!")
                .font(.system(size: DesignSystem.Typography.headline))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text("Complete exercises to track your progress")
                .font(.system(size: DesignSystem.Typography.body))
                .foregroundColor(DesignSystem.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(DesignSystem.Spacing.extraLarge)
        .cardStyle()
    }
}

// MARK: - Motivational Quote
struct MotivationalQuoteView: View {
    let quote: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.medium) {
            Image(systemName: "quote.opening")
                .font(.system(size: 20))
                .foregroundColor(DesignSystem.Colors.secondary)

            Text(quote)
                .font(.system(size: DesignSystem.Typography.body, weight: .medium))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .italic()

            Spacer()
        }
        .padding(DesignSystem.Spacing.medium)
        .background(DesignSystem.Colors.secondaryBackground)
        .cornerRadius(DesignSystem.CornerRadius.medium)
    }
}

// MARK: - Mini Line Chart
struct MiniLineChartView: View {
    let data: [Int]

    var body: some View {
        GeometryReader { geometry in
            if data.isEmpty {
                Text("No data yet")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            } else {
                Path { path in
                    guard let maxValue = data.max(), maxValue > 0 else { return }

                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepX = width / CGFloat(max(data.count - 1, 1))

                    for (index, value) in data.enumerated() {
                        let x = CGFloat(index) * stepX
                        let y = height - (CGFloat(value) / CGFloat(maxValue) * height * 0.8) - (height * 0.1)

                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(DesignSystem.Colors.primary, lineWidth: 2)
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    DashboardView()
}
