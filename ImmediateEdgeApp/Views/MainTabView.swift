//
//  MainTabView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            DashboardView()
                .tabItem {
                    Label("navHome".localized, systemImage: "house.fill")
                }
                .tag(0)

            // Train Tab
            TrainingSelectionView()
                .tabItem {
                    Label("navTrain".localized, systemImage: "figure.run")
                }
                .tag(1)

            // Progress Tab
            ProgressView()
                .tabItem {
                    Label("navProgress".localized, systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(2)

            // Library Tab
            LibraryView()
                .tabItem {
                    Label("navLibrary".localized, systemImage: "book.fill")
                }
                .tag(3)

            // Results Tab
            ProfileView()
                .tabItem {
                    Label("navResults".localized, systemImage: "trophy.fill")
                }
                .tag(4)
        }
        .accentColor(DesignSystem.Colors.primary)
    }
}

#Preview {
    MainTabView()
}
