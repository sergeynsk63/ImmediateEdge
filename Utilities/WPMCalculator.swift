//
//  WPMCalculator.swift
//  ImmediateEdgeApp
//
//

import Foundation

/// Utility for calculating Words Per Minute (WPM) reading speed
struct WPMCalculator {
    /// Calculates WPM based on total words and reading time
    /// - Parameters:
    ///   - wordsRead: Total number of words read
    ///   - timeInSeconds: Time taken to read in seconds
    /// - Returns: WPM rounded to nearest integer
    static func calculate(wordsRead: Int, timeInSeconds: Int) -> Int {
        guard timeInSeconds > 0 else { return 0 }
        let wpm = Double(wordsRead) / Double(timeInSeconds) * 60.0
        return Int(wpm.rounded())
    }

    /// Calculates estimated reading time for given word count
    /// - Parameters:
    ///   - wordCount: Number of words
    ///   - wpm: Reading speed in words per minute
    /// - Returns: Estimated time in minutes
    static func estimatedReadingTime(wordCount: Int, wpm: Int = AppConstants.defaultWPM) -> Int {
        guard wpm > 0 else { return 0 }
        return Int(ceil(Double(wordCount) / Double(wpm)))
    }

    /// Calculates reading speed category
    /// - Parameter wpm: Words per minute
    /// - Returns: Reading speed category
    static func speedCategory(wpm: Int) -> ReadingSpeedCategory {
        switch wpm {
        case 0..<200:
            return .slow
        case 200..<300:
            return .average
        case 300..<400:
            return .good
        case 400..<500:
            return .excellent
        default:
            return .exceptional
        }
    }
}

enum ReadingSpeedCategory: String {
    case slow = "Slow"
    case average = "Average"
    case good = "Good"
    case excellent = "Excellent"
    case exceptional = "Exceptional"

    var description: String {
        switch self {
        case .slow:
            return "Keep practicing! You're building your foundation."
        case .average:
            return "You're reading at an average pace. Great start!"
        case .good:
            return "Good speed! You're faster than most readers."
        case .excellent:
            return "Excellent! Your speed is impressive."
        case .exceptional:
            return "Exceptional! You're a speed reading master!"
        }
    }

    var color: String {
        switch self {
        case .slow:
            return "ErrorColor"
        case .average:
            return "WarningColor"
        case .good:
            return "SecondaryColor"
        case .excellent:
            return "SuccessColor"
        case .exceptional:
            return "PrimaryColor"
        }
    }
}
