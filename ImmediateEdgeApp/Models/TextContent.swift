//
//  TextContent.swift
//  ImmediateEdgeApp
//
//

import Foundation

struct TextContent: Identifiable, Codable {
    let id: String
    let title: String
    let category: TextCategory
    let difficulty: Difficulty
    let wordCount: Int
    let content: String
    let sourceAttribution: String?
    let questions: [Question]

    var estimatedReadingTime: Int {
        // Based on 250 WPM average
        return wordCount / 250
    }
}

enum TextCategory: String, Codable, CaseIterable {
    case business = "Business & Marketing"
    case science = "Science & Technology"
    case history = "History & Culture"
    case psychology = "Psychology & Personal Development"
    case literature = "Literature"
}

struct Question: Identifiable, Codable {
    let id: UUID
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let type: QuestionType

    init(
        id: UUID = UUID(),
        question: String,
        options: [String],
        correctAnswerIndex: Int,
        type: QuestionType
    ) {
        self.id = id
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.type = type
    }
}

enum QuestionType: String, Codable {
    case mainIdea = "main_idea"
    case details = "details"
    case inference = "inference"
    case vocabulary = "vocabulary"
    case purpose = "purpose"
}

struct TextLibrary: Codable {
    let texts: [TextContent]
}
