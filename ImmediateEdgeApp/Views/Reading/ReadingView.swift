//
//  ReadingView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ReadingView: View {
    let text: TextContent

    @State private var startTime = Date()
    @State private var showPostReading = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                    // Back Button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("buttonBack".localized)
                                    .font(.system(size: DesignSystem.Typography.body, weight: .medium))
                            }
                            .foregroundColor(DesignSystem.Colors.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(DesignSystem.Colors.secondaryBackground)
                            .cornerRadius(DesignSystem.CornerRadius.small)
                        }
                        Spacer()
                    }

                    // Header
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text(text.title)
                            .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        HStack {
                            Text(text.category.rawValue)
                                .font(.system(size: DesignSystem.Typography.caption))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .cornerRadius(6)

                            Text("\(text.wordCount) words")
                                .font(.system(size: DesignSystem.Typography.caption))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }

                    Divider()

                    // Content
                    Text(text.content)
                        .font(.system(size: DesignSystem.Typography.readingMedium))
                        .foregroundColor(DesignSystem.Colors.textPrimary)
                        .lineSpacing(8)

                    // Finish Button
                    PrimaryButton(title: "buttonFinishReading".localized) {
                        showPostReading = true
                    }
                    .padding(.top, DesignSystem.Spacing.large)
                }
                .padding()
            }

            // Hidden NavigationLink
            NavigationLink(
                destination: PostReadingView(
                    text: text,
                    readingTime: Int(Date().timeIntervalSince(startTime))
                ),
                isActive: $showPostReading
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ReadingView(text: TextLibraryData.allTexts[0])
    }
}
