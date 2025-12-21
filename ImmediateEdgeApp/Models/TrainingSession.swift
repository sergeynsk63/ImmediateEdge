//
//  TrainingSession.swift
//  ImmediateEdgeApp
//
//

import Foundation

struct TrainingSession: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let date: Date
    let type: ExerciseType
    let duration: Int // in seconds
    let wordsRead: Int?
    let wpm: Int?
    let comprehensionScore: Float?
    let settings: SessionSettings

    init(
        id: UUID = UUID(),
        userId: UUID,
        date: Date = Date(),
        type: ExerciseType,
        duration: Int,
        wordsRead: Int? = nil,
        wpm: Int? = nil,
        comprehensionScore: Float? = nil,
        settings: SessionSettings
    ) {
        self.id = id
        self.userId = userId
        self.date = date
        self.type = type
        self.duration = duration
        self.wordsRead = wordsRead
        self.wpm = wpm
        self.comprehensionScore = comprehensionScore
        self.settings = settings
    }
}

enum ExerciseType: String, Codable, CaseIterable {
    case rsvp = "RSVP"
    case schulte = "Schulte"
    case chunking = "Chunking"
    case freeReading = "FreeReading"
}

struct SessionSettings: Codable {
    var speed: Int?
    var chunkSize: Int?
    var difficulty: Difficulty?
    var textId: String?

    init(
        speed: Int? = nil,
        chunkSize: Int? = nil,
        difficulty: Difficulty? = nil,
        textId: String? = nil
    ) {
        self.speed = speed
        self.chunkSize = chunkSize
        self.difficulty = difficulty
        self.textId = textId
    }
}
