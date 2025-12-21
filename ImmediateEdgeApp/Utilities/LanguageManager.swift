//
//  LanguageManager.swift
//  ImmediateEdgeApp
//
//

import Foundation

/// Manages app language based on device settings
class LanguageManager {
    static let shared = LanguageManager()

    /// Supported languages in the app
    let supportedLanguages = ["en", "de", "es", "fr", "it"]

    /// Default language when device language is not supported
    let defaultLanguage = "en"

    private init() {}

    /// Detects and returns the appropriate language based on device settings
    func detectLanguage() -> String {
        // Get device preferred languages
        let preferredLanguages = Locale.preferredLanguages

        // Try to match the first preferred language
        for preferredLanguage in preferredLanguages {
            // Extract language code (e.g., "en" from "en-US")
            let languageCode = String(preferredLanguage.prefix(2))

            if supportedLanguages.contains(languageCode) {
                return languageCode
            }
        }

        // If no match found, return default language
        return defaultLanguage
    }

    /// Gets the display name for a language code
    func displayName(for languageCode: String) -> String {
        switch languageCode {
        case "en": return "English"
        case "de": return "Deutsch"
        case "es": return "Español"
        case "fr": return "Français"
        case "it": return "Italiano"
        default: return "English"
        }
    }

    /// Sets up the initial language for the app
    func setupInitialLanguage() {
        let currentLanguage = UserDefaults.standard.appLanguage

        // If no language is set yet, detect from device
        if currentLanguage.isEmpty || currentLanguage == "en" && UserDefaults.standard.object(forKey: UserDefaults.Keys.appLanguage) == nil {
            let detectedLanguage = detectLanguage()
            UserDefaults.standard.appLanguage = detectedLanguage
        }
    }
}
