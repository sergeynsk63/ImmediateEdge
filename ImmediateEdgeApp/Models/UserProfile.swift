//
//  UserProfile.swift
//  ImmediateEdgeApp
//
//

import Foundation

struct UserProfile: Identifiable, Codable {
    let id: UUID
    var username: String
    let createdAt: Date
    var language: String
    var currentStreak: Int
    var longestStreak: Int
    var lastTrainingDate: Date?
    var preferences: UserPreferences

    init(
        id: UUID = UUID(),
        username: String = "Reader",
        createdAt: Date = Date(),
        language: String = "en",
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastTrainingDate: Date? = nil,
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.username = username
        self.createdAt = createdAt
        self.language = language
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastTrainingDate = lastTrainingDate
        self.preferences = preferences
    }
}

struct UserPreferences: Codable {
    var theme: Theme
    var fontSize: FontSize
    var fontFamily: String
    var defaultExerciseDuration: Int
    var preferredDifficulty: Difficulty
    var notificationsEnabled: Bool
    var reminderTime: Date?
    var reminderDays: [Weekday]

    init(
        theme: Theme = .system,
        fontSize: FontSize = .medium,
        fontFamily: String = "System",
        defaultExerciseDuration: Int = 5,
        preferredDifficulty: Difficulty = .intermediate,
        notificationsEnabled: Bool = false,
        reminderTime: Date? = nil,
        reminderDays: [Weekday] = []
    ) {
        self.theme = theme
        self.fontSize = fontSize
        self.fontFamily = fontFamily
        self.defaultExerciseDuration = defaultExerciseDuration
        self.preferredDifficulty = preferredDifficulty
        self.notificationsEnabled = notificationsEnabled
        self.reminderTime = reminderTime
        self.reminderDays = reminderDays
    }
}

enum Theme: String, Codable, CaseIterable {
    case light
    case dark
    case system
}

enum FontSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

enum Difficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
}

enum Weekday: String, Codable, CaseIterable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}
