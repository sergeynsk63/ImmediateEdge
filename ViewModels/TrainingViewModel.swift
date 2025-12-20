//
//  TrainingViewModel.swift
//  ImmediateEdgeApp
//
//

import Foundation
import Combine

@MainActor
class TrainingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isTraining: Bool = false
    @Published var currentExercise: ExerciseType?
    @Published var sessionStartTime: Date?
    @Published var wordsRead: Int = 0
    @Published var currentWPM: Int = 0

    // MARK: - Dependencies
    private let dataManager = DataManager.shared
    private let statisticsService = StatisticsService.shared
    private let achievementService = AchievementService.shared

    // MARK: - Public Methods
    func startSession(type: ExerciseType) {
        currentExercise = type
        sessionStartTime = Date()
        isTraining = true
        wordsRead = 0
    }

    func endSession(
        wordsRead totalWords: Int,
        comprehensionScore: Float?,
        settings: SessionSettings
    ) {
        guard let userId = dataManager.fetchUserProfile()?.id,
              let startTime = sessionStartTime else {
            return
        }

        let duration = Int(Date().timeIntervalSince(startTime))
        let wpm = WPMCalculator.calculate(wordsRead: totalWords, timeInSeconds: duration)

        let session = TrainingSession(
            userId: userId,
            type: currentExercise ?? .rsvp,
            duration: duration,
            wordsRead: totalWords,
            wpm: wpm,
            comprehensionScore: comprehensionScore,
            settings: settings
        )

        // Save session
        dataManager.saveTrainingSession(session)

        // Update statistics
        let statistics = statisticsService.calculateStatistics(for: userId)
        achievementService.checkAchievements(statistics: statistics)

        // Update streak
        _ = statisticsService.updateStreak(for: userId)

        // Reset state
        isTraining = false
        currentExercise = nil
        sessionStartTime = nil
        wordsRead = 0
    }

    func cancelSession() {
        isTraining = false
        currentExercise = nil
        sessionStartTime = nil
        wordsRead = 0
    }
}
