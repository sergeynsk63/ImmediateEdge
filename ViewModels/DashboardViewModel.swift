//
//  DashboardViewModel.swift
//  ImmediateEdgeApp
//
//

import Foundation
import SwiftUI
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentWPM: Int = 0
    @Published var averageComprehension: Float = 0
    @Published var currentStreak: Int = 0
    @Published var totalSessions: Int = 0
    @Published var recentProgress: [SessionSummary] = []
    @Published var isLoading: Bool = false
    @Published var motivationalQuote: String = ""
    @Published var userProfile: UserProfile?

    // MARK: - Dependencies
    private let dataManager = DataManager.shared
    private let statisticsService = StatisticsService.shared
    private let achievementService = AchievementService.shared

    // MARK: - Initialization
    init() {
        loadDashboardData()
    }

    // MARK: - Public Methods
    func loadDashboardData() {
        isLoading = true

        // Load user profile
        userProfile = dataManager.fetchUserProfile()

        guard let profile = userProfile else {
            // No profile yet (shouldn't happen after onboarding)
            isLoading = false
            return
        }

        // Load statistics
        let statistics = statisticsService.calculateStatistics(for: profile.id)

        currentWPM = statistics.currentWPM
        averageComprehension = statistics.averageComprehension
        totalSessions = statistics.totalSessions

        // Update streak
        let (current, _) = statisticsService.updateStreak(for: profile.id)
        currentStreak = current

        // Load recent progress (last 7 days)
        recentProgress = statisticsService.getWPMProgress(for: 7)

        // Update achievements
        achievementService.checkAchievements(statistics: statistics)

        // Set motivational quote
        motivationalQuote = getMotivationalQuote()

        isLoading = false
    }

    func refreshData() {
        loadDashboardData()
    }

    // MARK: - Private Methods
    private func getMotivationalQuote() -> String {
        let quotes = [
            "The more that you read, the more things you will know.",
            "Today a reader, tomorrow a leader.",
            "Reading is to the mind what exercise is to the body.",
            "A book is a dream that you hold in your hand.",
            "The reading of all good books is like conversation with the finest minds.",
            "Reading is essential for those who seek to rise above the ordinary.",
            "The man who does not read has no advantage over the man who cannot read.",
            "Books are a uniquely portable magic.",
            "There is no friend as loyal as a book.",
            "Reading gives us someplace to go when we have to stay where we are."
        ]

        return quotes.randomElement() ?? quotes[0]
    }

    // MARK: - Computed Properties
    var comprehensionPercentage: String {
        String(format: "%.0f%%", averageComprehension * 100)
    }

    var hasData: Bool {
        totalSessions > 0
    }

    var streakEmoji: String {
        switch currentStreak {
        case 0:
            return "🌱"
        case 1...6:
            return "🔥"
        case 7...29:
            return "💪"
        case 30...99:
            return "⭐️"
        default:
            return "👑"
        }
    }

    var welcomeMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String

        switch hour {
        case 5..<12:
            greeting = "Good Morning"
        case 12..<17:
            greeting = "Good Afternoon"
        case 17..<22:
            greeting = "Good Evening"
        default:
            greeting = "Hello"
        }

        let name = userProfile?.username ?? "Reader"
        return "\(greeting), \(name)!"
    }

    var progressTrend: ProgressTrend {
        guard recentProgress.count >= 2 else { return .stable }

        let recentWPMs = recentProgress.compactMap { $0.wpm }
        guard recentWPMs.count >= 2 else { return .stable }

        let recent = recentWPMs.suffix(3)
        let older = recentWPMs.prefix(max(recentWPMs.count - 3, 0))

        let recentAvg = recent.reduce(0, +) / recent.count
        let olderAvg = older.isEmpty ? recentAvg : older.reduce(0, +) / older.count

        let difference = Double(recentAvg - olderAvg) / Double(olderAvg)

        if difference > 0.05 {
            return .improving
        } else if difference < -0.05 {
            return .declining
        } else {
            return .stable
        }
    }
}

// MARK: - Progress Trend
enum ProgressTrend {
    case improving
    case stable
    case declining

    var icon: String {
        switch self {
        case .improving: return "arrow.up.right"
        case .stable: return "arrow.right"
        case .declining: return "arrow.down.right"
        }
    }

    var color: Color {
        switch self {
        case .improving: return DesignSystem.Colors.success
        case .stable: return DesignSystem.Colors.secondary
        case .declining: return DesignSystem.Colors.warning
        }
    }

    var message: String {
        switch self {
        case .improving: return "Your speed is improving! 📈"
        case .stable: return "Keep up the good work! 💪"
        case .declining: return "Stay consistent with your training 🎯"
        }
    }
}
