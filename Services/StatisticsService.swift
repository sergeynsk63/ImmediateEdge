//
//  StatisticsService.swift
//  ImmediateEdgeApp
//
//

import Foundation
import Combine
import SwiftUI

/// Service for calculating and managing user statistics
class StatisticsService: ObservableObject {
    static let shared = StatisticsService()

    private let dataManager = DataManager.shared

    @Published var lastUpdated: Date = Date()

    private init() {}

    // MARK: - Calculate Statistics
    func calculateStatistics(for userId: UUID) -> Statistics {
        let sessions = dataManager.fetchTrainingSessions()

        let totalSessions = sessions.count
        let totalWordsRead = sessions.reduce(0) { $0 + ($1.wordsRead ?? 0) }
        let totalTrainingTime = sessions.reduce(0) { $0 + $1.duration }

        // Current WPM (from most recent session)
        let currentWPM = sessions.first?.wpm ?? 0

        // Best WPM
        let bestWPM = sessions.compactMap { $0.wpm }.max() ?? 0

        // Comprehension statistics
        let comprehensionScores = sessions.compactMap { $0.comprehensionScore }
        let averageComprehension = comprehensionScores.isEmpty ? 0 :
            comprehensionScores.reduce(0, +) / Float(comprehensionScores.count)
        let bestComprehension = comprehensionScores.max() ?? 0

        // Session history
        let sessionHistory = sessions.map { session in
            SessionSummary(
                date: session.date,
                wpm: session.wpm,
                comprehension: session.comprehensionScore,
                wordsRead: session.wordsRead ?? 0
            )
        }

        return Statistics(
            userId: userId,
            totalSessions: totalSessions,
            totalWordsRead: totalWordsRead,
            totalTrainingTime: totalTrainingTime,
            currentWPM: currentWPM,
            bestWPM: bestWPM,
            averageComprehension: averageComprehension,
            bestComprehension: bestComprehension,
            sessionHistory: sessionHistory
        )
    }

    // MARK: - Update Statistics After Session
    func updateStatistics(with session: TrainingSession) {
        // Statistics are calculated on-demand, so no need to store separately
        // This method can be used for any post-session processing if needed
    }

    // MARK: - Get WPM Progress
    func getWPMProgress(for days: Int) -> [SessionSummary] {
        let sessions = dataManager.fetchTrainingSessions()
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()

        return sessions
            .filter { $0.date >= cutoffDate }
            .map { session in
                SessionSummary(
                    date: session.date,
                    wpm: session.wpm,
                    comprehension: session.comprehensionScore,
                    wordsRead: session.wordsRead ?? 0
                )
            }
            .reversed() // Oldest first for chart display
    }

    // MARK: - Get Comprehension Progress
    func getComprehensionProgress(for days: Int) -> [SessionSummary] {
        return getWPMProgress(for: days).filter { $0.comprehension != nil }
    }

    // MARK: - Get Activity Calendar Data
    func getActivityCalendar() -> [Date: Int] {
        let sessions = dataManager.fetchTrainingSessions()
        var activityMap: [Date: Int] = [:]

        for session in sessions {
            let startOfDay = session.date.startOfDay
            activityMap[startOfDay, default: 0] += 1
        }

        return activityMap
    }

    // MARK: - Export Statistics
    func exportStatistics(for userId: UUID) -> String {
        let statistics = calculateStatistics(for: userId)
        var csv = "Date,WPM,Comprehension,Words Read\n"

        for summary in statistics.sessionHistory {
            let dateString = summary.date.formatted(style: .short)
            let wpmString = summary.wpm.map { String($0) } ?? "N/A"
            let comprehensionString = summary.comprehension.map { String(format: "%.2f", $0) } ?? "N/A"
            csv += "\(dateString),\(wpmString),\(comprehensionString),\(summary.wordsRead)\n"
        }

        return csv
    }

    // MARK: - Calculate Streak
    func updateStreak(for userId: UUID) -> (current: Int, longest: Int) {
        guard var profile = dataManager.fetchUserProfile() else {
            return (0, 0)
        }

        let sessions = dataManager.fetchTrainingSessions()
        guard !sessions.isEmpty else {
            return (0, profile.longestStreak)
        }

        // Get unique days with sessions
        let sessionDates = sessions.map { $0.date.startOfDay }.removingDuplicates().sorted(by: >)

        // Calculate current streak
        var currentStreak = 0
        let today = Date().startOfDay

        for (index, date) in sessionDates.enumerated() {
            let expectedDate = Calendar.current.date(byAdding: .day, value: -index, to: today)!
            if date.isSameDay(as: expectedDate) {
                currentStreak += 1
            } else {
                break
            }
        }

        // Update profile
        profile.currentStreak = currentStreak
        profile.longestStreak = max(profile.longestStreak, currentStreak)
        profile.lastTrainingDate = sessions.first?.date

        dataManager.updateUserProfile(profile)

        return (currentStreak, profile.longestStreak)
    }
}
