//
//  Achievement.swift
//  ImmediateEdgeApp
//
//

import Foundation

struct Achievement: Identifiable, Codable {
    let id: String
    let nameKey: String
    let descriptionKey: String
    let iconName: String
    let category: AchievementCategory
    var requirement: AchievementRequirement
    var isUnlocked: Bool
    var unlockedAt: Date?
    var progress: Float // 0.0 - 1.0

    var progressPercentage: Int {
        Int(progress * 100)
    }
}

enum AchievementCategory: String, Codable {
    case gettingStarted = "getting_started"
    case speed = "homeSpeedLabel"
    case comprehension = "homeComprehensionLabel"
    case reading = "reading"
    case consistency = "consistency"
    case variety = "variety"
}

struct AchievementRequirement: Codable {
    let type: RequirementType
    let targetValue: Int
    var currentValue: Int

    var progress: Float {
        guard targetValue > 0 else { return 0 }
        return min(Float(currentValue) / Float(targetValue), 1.0)
    }
}

enum RequirementType: String, Codable {
    case sessionsCompleted = "sessions_completed"
    case wpmReached = "wpm_reached"
    case comprehensionCount = "comprehension_count"
    case wordsRead = "words_read"
    case streakDays = "streak_days"
    case textsRead = "texts_read"
    case exercisesCompleted = "exercises_completed"
    case categoriesRead = "categories_read"
}
