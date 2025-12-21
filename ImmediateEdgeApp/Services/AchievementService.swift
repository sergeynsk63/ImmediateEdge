//
//  AchievementService.swift
//  ImmediateEdgeApp
//
//

import Foundation
import Combine

/// Service for managing achievements
class AchievementService: ObservableObject {
    static let shared = AchievementService()

    @Published var achievements: [Achievement] = []
    @Published var recentlyUnlocked: Achievement?

    private init() {
        loadAchievements()
    }

    // MARK: - Load Achievements
    private func loadAchievements() {
        achievements = [
            // Getting Started
            Achievement(
                id: "first_steps",
                nameKey: "achievementFirstSteps",
                descriptionKey: "achievementFirstStepsDesc",
                iconName: "star.fill",
                category: .gettingStarted,
                requirement: AchievementRequirement(type: .sessionsCompleted, targetValue: 1, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "speed_reader",
                nameKey: "achievementSpeedReader",
                descriptionKey: "achievementSpeedReaderDesc",
                iconName: "bolt.fill",
                category: .gettingStarted,
                requirement: AchievementRequirement(type: .sessionsCompleted, targetValue: 10, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "dedicated_learner",
                nameKey: "achievementDedicatedLearner",
                descriptionKey: "achievementDedicatedLearnerDesc",
                iconName: "book.fill",
                category: .gettingStarted,
                requirement: AchievementRequirement(type: .sessionsCompleted, targetValue: 50, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "speed_master",
                nameKey: "achievementSpeedMaster",
                descriptionKey: "achievementSpeedMasterDesc",
                iconName: "crown.fill",
                category: .gettingStarted,
                requirement: AchievementRequirement(type: .sessionsCompleted, targetValue: 100, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),

            // Speed Achievements
            Achievement(
                id: "fast_reader",
                nameKey: "achievementFastReader",
                descriptionKey: "achievementFastReaderDesc",
                iconName: "hare.fill",
                category: .speed,
                requirement: AchievementRequirement(type: .wpmReached, targetValue: 300, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "super_speedy",
                nameKey: "achievement.super_speedy.name",
                descriptionKey: "achievement.super_speedy.description",
                iconName: "flame.fill",
                category: .speed,
                requirement: AchievementRequirement(type: .wpmReached, targetValue: 400, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "lightning_fast",
                nameKey: "achievement.lightning_fast.name",
                descriptionKey: "achievement.lightning_fast.description",
                iconName: "bolt.circle.fill",
                category: .speed,
                requirement: AchievementRequirement(type: .wpmReached, targetValue: 500, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "unstoppable_speed",
                nameKey: "achievement.unstoppable_speed.name",
                descriptionKey: "achievement.unstoppable_speed.description",
                iconName: "sparkles",
                category: .speed,
                requirement: AchievementRequirement(type: .wpmReached, targetValue: 600, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),

            // Comprehension Achievements
            Achievement(
                id: "good_understanding",
                nameKey: "achievement.good_understanding.name",
                descriptionKey: "achievement.good_understanding.description",
                iconName: "brain.head.profile",
                category: .comprehension,
                requirement: AchievementRequirement(type: .comprehensionCount, targetValue: 5, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "great_comprehension",
                nameKey: "achievement.great_comprehension.name",
                descriptionKey: "achievement.great_comprehension.description",
                iconName: "brain.fill",
                category: .comprehension,
                requirement: AchievementRequirement(type: .comprehensionCount, targetValue: 5, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "perfect_score",
                nameKey: "achievement.perfect_score.name",
                descriptionKey: "achievement.perfect_score.description",
                iconName: "star.circle.fill",
                category: .comprehension,
                requirement: AchievementRequirement(type: .comprehensionCount, targetValue: 1, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),

            // Reading Achievements
            Achievement(
                id: "book_worm",
                nameKey: "achievement.book_worm.name",
                descriptionKey: "achievement.book_worm.description",
                iconName: "book.closed.fill",
                category: .reading,
                requirement: AchievementRequirement(type: .wordsRead, targetValue: 10000, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "avid_reader",
                nameKey: "achievement.avid_reader.name",
                descriptionKey: "achievement.avid_reader.description",
                iconName: "books.vertical.fill",
                category: .reading,
                requirement: AchievementRequirement(type: .wordsRead, targetValue: 50000, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "reading_champion",
                nameKey: "achievement.reading_champion.name",
                descriptionKey: "achievement.reading_champion.description",
                iconName: "trophy.fill",
                category: .reading,
                requirement: AchievementRequirement(type: .wordsRead, targetValue: 100000, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "library_master",
                nameKey: "achievement.library_master.name",
                descriptionKey: "achievement.library_master.description",
                iconName: "building.columns.fill",
                category: .reading,
                requirement: AchievementRequirement(type: .textsRead, targetValue: 20, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),

            // Consistency Achievements
            Achievement(
                id: "week_warrior",
                nameKey: "achievement.week_warrior.name",
                descriptionKey: "achievement.week_warrior.description",
                iconName: "statisticsCalendarLabel",
                category: .consistency,
                requirement: AchievementRequirement(type: .streakDays, targetValue: 7, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "month_master",
                nameKey: "achievement.month_master.name",
                descriptionKey: "achievement.month_master.description",
                iconName: "calendar.badge.clock",
                category: .consistency,
                requirement: AchievementRequirement(type: .streakDays, targetValue: 30, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "unstoppable_streak",
                nameKey: "achievement.unstoppable_streak.name",
                descriptionKey: "achievement.unstoppable_streak.description",
                iconName: "flame.circle.fill",
                category: .consistency,
                requirement: AchievementRequirement(type: .streakDays, targetValue: 100, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),

            // Variety Achievements
            Achievement(
                id: "explorer",
                nameKey: "achievement.explorer.name",
                descriptionKey: "achievement.explorer.description",
                iconName: "map.fill",
                category: .variety,
                requirement: AchievementRequirement(type: .exercisesCompleted, targetValue: 3, currentValue: 0),
                isUnlocked: false,
                progress: 0
            ),
            Achievement(
                id: "well_rounded",
                nameKey: "achievement.well_rounded.name",
                descriptionKey: "achievement.well_rounded.description",
                iconName: "circle.grid.3x3.fill",
                category: .variety,
                requirement: AchievementRequirement(type: .categoriesRead, targetValue: 5, currentValue: 0),
                isUnlocked: false,
                progress: 0
            )
        ]
    }

    // MARK: - Check and Update Achievements
    func checkAchievements(statistics: Statistics) {
        for index in achievements.indices {
            var achievement = achievements[index]
            if achievement.isUnlocked { continue }

            var shouldCheck = false
            var currentValue = 0

            switch achievement.requirement.type {
            case .sessionsCompleted:
                currentValue = statistics.totalSessions
                shouldCheck = true
            case .wpmReached:
                currentValue = statistics.bestWPM
                shouldCheck = true
            case .wordsRead:
                currentValue = statistics.totalWordsRead
                shouldCheck = true
            case .streakDays:
                if let profile = DataManager.shared.fetchUserProfile() {
                    currentValue = profile.currentStreak
                    shouldCheck = true
                }
            default:
                break
            }

            if shouldCheck {
                achievement.requirement.currentValue = currentValue
                achievement.progress = achievement.requirement.progress

                if currentValue >= achievement.requirement.targetValue && !achievement.isUnlocked {
                    achievement.isUnlocked = true
                    achievement.unlockedAt = Date()
                    recentlyUnlocked = achievement
                }

                achievements[index] = achievement
            }
        }
    }

    // MARK: - Get Achievements by Category
    func achievements(in category: AchievementCategory) -> [Achievement] {
        return achievements.filter { $0.category == category }
    }

    // MARK: - Get Unlocked Count
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }

    var totalCount: Int {
        achievements.count
    }
}
