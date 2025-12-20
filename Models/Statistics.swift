//
//  Statistics.swift
//  ImmediateEdgeApp
//
//

import Foundation

struct Statistics: Codable {
    let userId: UUID
    var totalSessions: Int
    var totalWordsRead: Int
    var totalTrainingTime: Int // in seconds
    var currentWPM: Int
    var bestWPM: Int
    var averageComprehension: Float
    var bestComprehension: Float
    var sessionHistory: [SessionSummary]

    init(
        userId: UUID,
        totalSessions: Int = 0,
        totalWordsRead: Int = 0,
        totalTrainingTime: Int = 0,
        currentWPM: Int = 0,
        bestWPM: Int = 0,
        averageComprehension: Float = 0,
        bestComprehension: Float = 0,
        sessionHistory: [SessionSummary] = []
    ) {
        self.userId = userId
        self.totalSessions = totalSessions
        self.totalWordsRead = totalWordsRead
        self.totalTrainingTime = totalTrainingTime
        self.currentWPM = currentWPM
        self.bestWPM = bestWPM
        self.averageComprehension = averageComprehension
        self.bestComprehension = bestComprehension
        self.sessionHistory = sessionHistory
    }
}

struct SessionSummary: Codable, Identifiable {
    let id: UUID
    let date: Date
    let wpm: Int?
    let comprehension: Float?
    let wordsRead: Int

    init(
        id: UUID = UUID(),
        date: Date,
        wpm: Int? = nil,
        comprehension: Float? = nil,
        wordsRead: Int
    ) {
        self.id = id
        self.date = date
        self.wpm = wpm
        self.comprehension = comprehension
        self.wordsRead = wordsRead
    }
}
