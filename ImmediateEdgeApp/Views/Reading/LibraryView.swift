//
//  LibraryView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var libraryService = TextLibraryService.shared
    @State private var selectedCategory: TextCategory? = nil
    @State private var selectedDifficulty: Difficulty? = nil
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DesignSystem.Spacing.small) {
                        FilterChip(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                            applyFilters()
                        }

                        ForEach(TextCategory.allCases, id: \.self) { category in
                            FilterChip(title: category.rawValue, isSelected: selectedCategory == category) {
                                selectedCategory = category
                                applyFilters()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, DesignSystem.Spacing.small)

                // Text List
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.medium) {
                        ForEach(libraryService.filteredTexts) { text in
                            NavigationLink(destination: ReadingView(text: text)) {
                                TextCard(text: text)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("libraryTitle".localized)
            .searchable(text: $searchText)
            .onChange(of: searchText) { _ in
                applyFilters()
            }
        }
    }

    private func applyFilters() {
        libraryService.filterTexts(
            category: selectedCategory,
            difficulty: selectedDifficulty,
            searchQuery: searchText
        )
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: DesignSystem.Typography.subhead, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : DesignSystem.Colors.textPrimary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? DesignSystem.Colors.primary : DesignSystem.Colors.secondaryBackground)
                .cornerRadius(20)
        }
    }
}

// MARK: - Text Card
struct TextCard: View {
    let text: TextContent

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            // Title & Category
            HStack {
                Text(text.title)
                    .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Text(text.category.rawValue)
                    .font(.system(size: DesignSystem.Typography.caption))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(categoryColor(text.category))
                    .cornerRadius(8)
            }

            // Metadata
            HStack(spacing: DesignSystem.Spacing.medium) {
                Label("\(text.wordCount) words", systemImage: "doc.text")
                Label("\(text.estimatedReadingTime) min", systemImage: "clock")
                Label(text.difficulty.rawValue.capitalized, systemImage: difficultyIcon(text.difficulty))
            }
            .font(.system(size: DesignSystem.Typography.caption))
            .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .padding()
        .cardStyle()
    }

    private func categoryColor(_ category: TextCategory) -> Color {
        switch category {
        case .business: return .blue
        case .science: return .purple
        case .history: return .orange
        case .psychology: return .green
        case .literature: return .red
        }
    }

    private func difficultyIcon(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .beginner: return "star"
        case .intermediate: return "star.fill"
        case .advanced: return "flame.fill"
        }
    }
}

#Preview {
    LibraryView()
}
