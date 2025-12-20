//
//  StatisticsViewModel.swift
//  ImmediateEdgeApp
//
//

import Foundation
import Combine

@MainActor
class StatisticsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var statistics: Statistics?
    @Published var selectedTimeRange: TimeRange = .sevenDays
    @Published var wpmProgress: [SessionSummary] = []
    @Published var comprehensionProgress: [SessionSummary] = []
    @Published var activityCalendar: [Date: Int] = [:]
    @Published var isLoading: Bool = false

    enum TimeRange: String, CaseIterable {
        case sevenDays = "statisticsTimeRangeWeek"
        case thirtyDays = "statisticsTimeRangeMonth"
        case allTime = "statisticsTimeRangeAllTime"

        var days: Int? {
            switch self {
            case .sevenDays: return 7
            case .thirtyDays: return 30
            case .allTime: return nil
            }
        }
    }

    // MARK: - Dependencies
    private let dataManager = DataManager.shared
    private let statisticsService = StatisticsService.shared

    // MARK: - Initialization
    init() {
        loadStatistics()
    }

    // MARK: - Public Methods
    func loadStatistics() {
        isLoading = true

        guard let profile = dataManager.fetchUserProfile() else {
            isLoading = false
            return
        }

        // Load overall statistics
        statistics = statisticsService.calculateStatistics(for: profile.id)

        // Load progress data
        updateProgressData()

        // Load activity calendar
        activityCalendar = statisticsService.getActivityCalendar()

        isLoading = false
    }

    func changeTimeRange(_ range: TimeRange) {
        selectedTimeRange = range
        updateProgressData()
    }

    func exportData() -> String {
        guard let profile = dataManager.fetchUserProfile() else {
            return ""
        }

        return statisticsService.exportStatistics(for: profile.id)
    }

    // MARK: - Private Methods
    private func updateProgressData() {
        if let days = selectedTimeRange.days {
            wpmProgress = statisticsService.getWPMProgress(for: days)
            comprehensionProgress = statisticsService.getComprehensionProgress(for: days)
        } else {
            // All time
            wpmProgress = dataManager.fetchTrainingSessions().map { session in
                SessionSummary(
                    date: session.date,
                    wpm: session.wpm,
                    comprehension: session.comprehensionScore,
                    wordsRead: session.wordsRead ?? 0
                )
            }
            comprehensionProgress = wpmProgress.filter { $0.comprehension != nil }
        }
    }

    // MARK: - Computed Properties
    var averageSessionDuration: String {
        guard let stats = statistics, stats.totalSessions > 0 else {
            return "0:00"
        }

        let avgSeconds = stats.totalTrainingTime / stats.totalSessions
        return avgSeconds.formattedTime
    }

    var totalTrainingTime: String {
        guard let stats = statistics else {
            return "0:00"
        }

        return stats.totalTrainingTime.formattedTime
    }

    var improvementRate: String {
        guard wpmProgress.count >= 2 else {
            return "N/A"
        }

        let wpms = wpmProgress.compactMap { $0.wpm }
        guard wpms.count >= 2 else {
            return "N/A"
        }

        let first = wpms.first ?? 0
        let last = wpms.last ?? 0

        guard first > 0 else {
            return "N/A"
        }

        let improvement = Double(last - first) / Double(first) * 100
        return String(format: "%.1f%%", improvement)
    }
}
