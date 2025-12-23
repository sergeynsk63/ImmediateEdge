//
//  ProgressView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ProgressView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    Text("Progress & Statistics")
                        .font(.title2)

                    Text("Coming soon...")
                        .foregroundColor(DesignSystem.Colors.textSecondary)
                }
                .padding()
            }
            .navigationTitle("statisticsTitle".localized)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ProgressView()
}
