//
//  DataManager.swift
//  ImmediateEdgeApp
//
//

import Foundation
import CoreData
import Combine

/// Main data manager for Core Data operations
class DataManager: ObservableObject {
    static let shared = DataManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "ImmediateEdge")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("⚠️ Core Data failed to load: \(error.localizedDescription)")
                print("⚠️ Description: \(description)")
                // Don't crash - log error and continue
                // fatalError("Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("✅ Core Data loaded successfully from: \(description.url?.absoluteString ?? "unknown")")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Save Context
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - User Profile Operations
    func createUserProfile(_ profile: UserProfile) {
        let entity = UserProfileEntity(context: context)
        entity.id = profile.id
        entity.username = profile.username
        entity.createdAt = profile.createdAt
        entity.language = profile.language
        entity.currentStreak = Int32(profile.currentStreak)
        entity.longestStreak = Int32(profile.longestStreak)
        entity.lastTrainingDate = profile.lastTrainingDate

        // Preferences
        entity.theme = profile.preferences.theme.rawValue
        entity.fontSize = profile.preferences.fontSize.rawValue
        entity.fontFamily = profile.preferences.fontFamily
        entity.defaultExerciseDuration = Int32(profile.preferences.defaultExerciseDuration)
        entity.preferredDifficulty = profile.preferences.preferredDifficulty.rawValue
        entity.notificationsEnabled = profile.preferences.notificationsEnabled
        entity.reminderTime = profile.preferences.reminderTime
        entity.reminderDays = profile.preferences.reminderDays.map { $0.rawValue }.joined(separator: ",")

        save()
    }

    func fetchUserProfile() -> UserProfile? {
        let request = UserProfileEntity.fetchRequest()
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            guard let entity = results.first else { return nil }
            return userProfileFromEntity(entity)
        } catch {
            print("Error fetching user profile: \(error)")
            return nil
        }
    }

    func updateUserProfile(_ profile: UserProfile) {
        let request = UserProfileEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", profile.id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let entity = results.first {
                entity.username = profile.username
                entity.language = profile.language
                entity.currentStreak = Int32(profile.currentStreak)
                entity.longestStreak = Int32(profile.longestStreak)
                entity.lastTrainingDate = profile.lastTrainingDate

                entity.theme = profile.preferences.theme.rawValue
                entity.fontSize = profile.preferences.fontSize.rawValue
                entity.fontFamily = profile.preferences.fontFamily
                entity.defaultExerciseDuration = Int32(profile.preferences.defaultExerciseDuration)
                entity.preferredDifficulty = profile.preferences.preferredDifficulty.rawValue
                entity.notificationsEnabled = profile.preferences.notificationsEnabled
                entity.reminderTime = profile.preferences.reminderTime
                entity.reminderDays = profile.preferences.reminderDays.map { $0.rawValue }.joined(separator: ",")

                save()
            }
        } catch {
            print("Error updating user profile: \(error)")
        }
    }

    // MARK: - Training Session Operations
    func saveTrainingSession(_ session: TrainingSession) {
        let entity = TrainingSessionEntity(context: context)
        entity.id = session.id
        entity.date = session.date
        entity.type = session.type.rawValue
        entity.duration = Int32(session.duration)
        entity.wordsRead = Int32(session.wordsRead ?? 0)
        entity.wpm = Int32(session.wpm ?? 0)
        entity.comprehensionScore = session.comprehensionScore ?? 0
        entity.speed = Int32(session.settings.speed ?? 0)
        entity.chunkSize = Int32(session.settings.chunkSize ?? 0)
        entity.difficulty = session.settings.difficulty?.rawValue
        entity.textId = session.settings.textId

        save()
    }

    func fetchTrainingSessions(limit: Int? = nil) -> [TrainingSession] {
        let request = TrainingSessionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let limit = limit {
            request.fetchLimit = limit
        }

        do {
            let results = try context.fetch(request)
            return results.compactMap { trainingSessionFromEntity($0) }
        } catch {
            print("Error fetching training sessions: \(error)")
            return []
        }
    }

    // MARK: - Helper Methods
    private func userProfileFromEntity(_ entity: UserProfileEntity) -> UserProfile {
        let reminderDaysString = entity.reminderDays ?? ""
        let reminderDays = reminderDaysString.isEmpty ? [] :
            reminderDaysString.split(separator: ",").compactMap { Weekday(rawValue: String($0)) }

        let preferences = UserPreferences(
            theme: Theme(rawValue: entity.theme ?? "profileThemeSystem") ?? .system,
            fontSize: FontSize(rawValue: entity.fontSize ?? "difficultyMedium") ?? .medium,
            fontFamily: entity.fontFamily ?? "System",
            defaultExerciseDuration: Int(entity.defaultExerciseDuration),
            preferredDifficulty: Difficulty(rawValue: entity.preferredDifficulty ?? "difficultyIntermediate") ?? .intermediate,
            notificationsEnabled: entity.notificationsEnabled,
            reminderTime: entity.reminderTime,
            reminderDays: reminderDays
        )

        return UserProfile(
            id: entity.id ?? UUID(),
            username: entity.username ?? "Reader",
            createdAt: entity.createdAt ?? Date(),
            language: entity.language ?? "en",
            currentStreak: Int(entity.currentStreak),
            longestStreak: Int(entity.longestStreak),
            lastTrainingDate: entity.lastTrainingDate,
            preferences: preferences
        )
    }

    private func trainingSessionFromEntity(_ entity: TrainingSessionEntity) -> TrainingSession? {
        guard let id = entity.id,
              let type = ExerciseType(rawValue: entity.type ?? "") else {
            return nil
        }

        let settings = SessionSettings(
            speed: entity.speed == 0 ? nil : Int(entity.speed),
            chunkSize: entity.chunkSize == 0 ? nil : Int(entity.chunkSize),
            difficulty: entity.difficulty.flatMap { Difficulty(rawValue: $0) },
            textId: entity.textId
        )

        return TrainingSession(
            id: id,
            userId: UUID(), // Will be properly linked
            date: entity.date ?? Date(),
            type: type,
            duration: Int(entity.duration),
            wordsRead: entity.wordsRead == 0 ? nil : Int(entity.wordsRead),
            wpm: entity.wpm == 0 ? nil : Int(entity.wpm),
            comprehensionScore: entity.comprehensionScore == 0 ? nil : entity.comprehensionScore,
            settings: settings
        )
    }
}
