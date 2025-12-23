//
//  ProfileViewModel.swift
//  ImmediateEdgeApp
//
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var userProfile: UserProfile?
    @Published var isLoading: Bool = false
    @Published var showResetAlert: Bool = false
    @Published var showDeleteAlert: Bool = false

    // MARK: - Dependencies
    private let dataManager = DataManager.shared

    // MARK: - Initialization
    init() {
        loadProfile()
    }

    // MARK: - Public Methods
    func loadProfile() {
        isLoading = true
        userProfile = dataManager.fetchUserProfile()
        isLoading = false
    }

    func updateProfile(_ profile: UserProfile) {
        dataManager.updateUserProfile(profile)
        loadProfile()
    }

    func updateUsername(_ newName: String) {
        guard var profile = userProfile else { return }
        profile.username = newName
        updateProfile(profile)
    }

    func updateLanguage(_ language: String) {
        guard var profile = userProfile else { return }
        profile.language = language
        UserDefaults.standard.appLanguage = language
        updateProfile(profile)
    }

    func updateTheme(_ theme: Theme) {
        guard var profile = userProfile else { return }
        profile.preferences.theme = theme
        updateProfile(profile)
    }

    func updateFontSize(_ size: FontSize) {
        guard var profile = userProfile else { return }
        profile.preferences.fontSize = size
        updateProfile(profile)
    }

    func updateNotifications(enabled: Bool) {
        guard var profile = userProfile else { return }
        profile.preferences.notificationsEnabled = enabled
        updateProfile(profile)
    }

    func resetStatistics() {
        // This would require clearing all session data
        // For now, we'll just show an alert
        showResetAlert = true
    }

    func deleteAccount() {
        showDeleteAlert = true
    }

    func confirmDelete() {
        // Clear all data and return to onboarding
        UserDefaults.standard.hasCompletedOnboarding = false
        UserDefaults.standard.currentUserId = nil
    }

    func deleteAllData() {
        // Delete all training sessions and user data
        dataManager.deleteAllData()
        UserDefaults.standard.hasCompletedOnboarding = false
        UserDefaults.standard.currentUserId = nil
    }

    // MARK: - Computed Properties
    var username: String {
        userProfile?.username ?? "Reader"
    }

    var userInitials: String {
        String(username.prefix(1)).uppercased()
    }

    var memberSinceText: String? {
        guard let profile = userProfile else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Member since \(formatter.string(from: profile.createdAt))"
    }

    var currentSpeed: Int {
        guard let userId = userProfile?.id else { return 0 }
        let stats = StatisticsService.shared.calculateStatistics(for: userId)
        return Int(stats.currentWPM)
    }

    var totalSessions: Int {
        dataManager.fetchTrainingSessions().count
    }

    var currentStreak: Int {
        guard let userId = userProfile?.id else { return 0 }
        let streaks = StatisticsService.shared.updateStreak(for: userId)
        return streaks.current
    }

    var totalWordsRead: Int {
        dataManager.fetchTrainingSessions().reduce(0) { $0 + ($1.wordsRead ?? 0) }
    }

    var appVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var shareText: String {
        """
        🎯 My Immediate Edge Reading Stats:

        📚 Reading Speed: \(currentSpeed) WPM
        ✅ Training Sessions: \(totalSessions)
        🔥 Current Streak: \(currentStreak) days
        📖 Total Words Read: \(totalWordsRead.formatted())

        Join me in mastering speed reading!
        """
    }

    var memberSince: String {
        guard let profile = userProfile else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: profile.createdAt)
    }

    var totalTrainingDays: Int {
        guard userProfile != nil else {
            return 0
        }

        let sessions = dataManager.fetchTrainingSessions()
        let uniqueDays = Set(sessions.map { Calendar.current.startOfDay(for: $0.date) })
        return uniqueDays.count
    }
}
