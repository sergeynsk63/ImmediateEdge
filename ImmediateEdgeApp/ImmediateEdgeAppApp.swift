//
//  ImmediateEdgeAppApp.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

@main
struct ImmediateEdgeAppApp: App {
    // Initialize Core Data
    let dataManager = DataManager.shared

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environment(\.managedObjectContext, dataManager.context)
            } else {
                WelcomeView()
                    .environment(\.managedObjectContext, dataManager.context)
            }
        }
    }
}
