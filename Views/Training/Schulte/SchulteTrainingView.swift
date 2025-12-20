//
//  SchulteTrainingView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct SchulteTrainingView: View {
    let difficulty: SchulteSettingsView.SchulteDifficulty
    let rounds: Int

    @State private var currentRound = 1
    @State private var currentTarget = 1
    @State private var gridNumbers: [Int] = []
    @State private var startTime: Date?
    @State private var roundTimes: [TimeInterval] = []
    @State private var incorrectTaps = 0
    @State private var navigateToResults = false
    @State private var shakeCell: Int?

    @Environment(\.dismiss) var dismiss

    private var gridSize: Int {
        difficulty.gridSize
    }

    private var totalNumbers: Int {
        gridSize * gridSize
    }

    private var elapsedTime: String {
        guard let start = startTime else { return "00:00" }
        let elapsed = Date().timeIntervalSince(start)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Text("\("round".localized) \(currentRound)/\(rounds)")
                            .font(.system(size: DesignSystem.Typography.body, weight: .semibold))
                        Text(elapsedTime)
                            .font(.system(size: DesignSystem.Typography.caption))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }

                    Spacer()

                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                Spacer()

                // Current Target Number
                VStack(spacing: DesignSystem.Spacing.small) {
                    Text("Find:")
                        .font(.system(size: DesignSystem.Typography.body))
                        .foregroundColor(DesignSystem.Colors.textSecondary)

                    Text("\(currentTarget)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.primary)
                        .frame(width: 80, height: 80)
                        .background(DesignSystem.Colors.primary.opacity(0.1))
                        .cornerRadius(16)
                }
                .padding(.bottom, DesignSystem.Spacing.large)

                // Schulte Grid
                GeometryReader { geometry in
                    let availableSize = min(geometry.size.width, geometry.size.height)
                    let cellSize = (availableSize - CGFloat(gridSize + 1) * 8) / CGFloat(gridSize)

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(cellSize), spacing: 8), count: gridSize),
                        spacing: 8
                    ) {
                        ForEach(gridNumbers, id: \.self) { number in
                            SchulteCell(
                                number: number,
                                size: cellSize,
                                isShaking: shakeCell == number
                            ) {
                                handleTap(on: number)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()

                Spacer()
            }

            // Hidden NavigationLink for results
            NavigationLink(
                destination: SchulteResultsView(
                    difficulty: difficulty,
                    totalRounds: rounds,
                    roundTimes: roundTimes,
                    incorrectTaps: incorrectTaps
                ),
                isActive: $navigateToResults
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarHidden(true)
        .onAppear {
            startRound()
        }
    }

    private func startRound() {
        currentTarget = 1
        generateGrid()
        startTime = Date()
    }

    private func generateGrid() {
        var numbers = Array(1...totalNumbers)
        numbers.shuffle()
        gridNumbers = numbers
    }

    private func handleTap(on number: Int) {
        if number == currentTarget {
            // Correct tap
            if currentTarget == totalNumbers {
                // Round complete
                completeRound()
            } else {
                // Move to next number
                currentTarget += 1
            }
        } else {
            // Incorrect tap - shake animation
            incorrectTaps += 1
            withAnimation(.default) {
                shakeCell = number
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shakeCell = nil
            }
        }
    }

    private func completeRound() {
        guard let start = startTime else { return }
        let roundTime = Date().timeIntervalSince(start)
        roundTimes.append(roundTime)

        if currentRound < rounds {
            // Start next round
            currentRound += 1
            startRound()
        } else {
            // All rounds complete
            navigateToResults = true
        }
    }
}

// MARK: - Schulte Cell
struct SchulteCell: View {
    let number: Int
    let size: CGFloat
    let isShaking: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: min(size * 0.4, 32), weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(width: size, height: size)
                .background(DesignSystem.Colors.secondaryBackground)
                .cornerRadius(12)
                .shadow(radius: 2)
        }
        .modifier(ShakeEffect(animatableData: isShaking ? 1 : 0))
    }
}

// MARK: - Shake Effect
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: 10 * sin(animatableData * .pi * 2),
                y: 0
            )
        )
    }
}

#Preview {
    NavigationView {
        SchulteTrainingView(
            difficulty: .easy,
            rounds: 3
        )
    }
}
