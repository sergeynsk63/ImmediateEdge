//
//  ChunkingTrainingView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct ChunkingTrainingView: View {
    let chunkSize: Int
    let speed: ChunkingSettingsView.ChunkingSpeed
    let duration: Int

    @State private var currentChunkIndex = 0
    @State private var isPaused = false
    @State private var showPauseMenu = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var chunkTimer: Timer?
    @State private var navigateToResults = false

    @Environment(\.dismiss) var dismiss

    private let trainingText = """
    Reading in chunks is a powerful technique for improving both speed and comprehension. Instead of reading word by word, your eyes learn to capture groups of words at once. This method reduces the number of eye movements required, allowing your brain to process information more efficiently.

    The key to successful chunking is practice and patience. Start with smaller chunks of two or three words, then gradually increase the size as you become more comfortable. Your peripheral vision plays a crucial role in this technique, enabling you to see and understand multiple words simultaneously.

    Studies have shown that skilled readers naturally use chunking without conscious effort. Their eyes move in smooth patterns across the page, taking in meaningful phrases rather than individual words. By training yourself to read in chunks, you're developing the same natural reading patterns that expert readers use every day.

    With consistent practice, chunking becomes second nature. You'll find yourself reading faster while maintaining or even improving your comprehension. The brain is remarkably adaptable, and it quickly learns to recognize and process word groups as single units of meaning.
    """

    private var words: [String] {
        trainingText.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
    }

    private var chunks: [[String]] {
        var result: [[String]] = []
        for i in stride(from: 0, to: words.count, by: chunkSize) {
            let endIndex = min(i + chunkSize, words.count)
            result.append(Array(words[i..<endIndex]))
        }
        return result
    }

    private var chunksRead: Int {
        min(currentChunkIndex + 1, chunks.count)
    }

    private var progress: Double {
        chunks.isEmpty ? 0 : Double(chunksRead) / Double(chunks.count)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        stopTraining()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    Text(formatTime(elapsedTime))
                        .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.textPrimary)

                    Spacer()

                    Button(action: {
                        togglePause()
                    }) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.primary)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                // Text Display Area with Highlighting
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Array(chunks.enumerated()), id: \.offset) { index, chunk in
                                Text(chunk.joined(separator: " ") + " ")
                                    .font(.system(size: DesignSystem.Typography.readingMedium))
                                    .foregroundColor(DesignSystem.Colors.textPrimary)
                                    .padding(4)
                                    .background(
                                        index == currentChunkIndex ?
                                            DesignSystem.Colors.primary.opacity(0.3) :
                                            Color.clear
                                    )
                                    .cornerRadius(4)
                                    .id(index)
                            }
                        }
                        .padding(DesignSystem.Spacing.large)
                    }
                    .onChange(of: currentChunkIndex) { newIndex in
                        withAnimation {
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }

                // Progress Bar
                VStack(spacing: DesignSystem.Spacing.small) {
                    SwiftUI.ProgressView(value: progress)
                        .tint(DesignSystem.Colors.primary)

                    HStack {
                        Text("\("chunk".localized) \(chunksRead)/\(chunks.count)")
                            .font(.system(size: DesignSystem.Typography.caption))
                            .foregroundColor(DesignSystem.Colors.textSecondary)

                        Spacer()

                        Text(String(format: "%.0f%%", progress * 100))
                            .font(.system(size: DesignSystem.Typography.caption))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
                .padding()
            }

            // Pause Menu Overlay
            if showPauseMenu {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showPauseMenu = false
                    }

                PauseMenuView(
                    currentSpeed: speed.interval,
                    onResume: {
                        showPauseMenu = false
                        togglePause()
                    },
                    onAdjustSpeed: { _ in
                        showPauseMenu = false
                        togglePause()
                    },
                    onExit: {
                        stopTraining()
                        dismiss()
                    }
                )
            }

            // Hidden NavigationLink for results
            NavigationLink(
                destination: ChunkingResultsView(
                    chunksRead: chunksRead,
                    chunkSize: chunkSize,
                    timeSpent: Int(elapsedTime)
                ),
                isActive: $navigateToResults
            ) {
                EmptyView()
            }
            .hidden()
        }
        .navigationBarHidden(true)
        .onAppear {
            startTraining()
        }
        .onDisappear {
            stopTraining()
        }
    }

    private func startTraining() {
        // Start elapsed time timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if !isPaused {
                elapsedTime += 1

                // Check if duration is reached
                if Int(elapsedTime) >= duration * 60 {
                    completeTraining()
                }
            }
        }

        // Start chunk highlight timer
        startChunkTimer()
    }

    private func startChunkTimer() {
        chunkTimer = Timer.scheduledTimer(withTimeInterval: speed.interval, repeats: true) { _ in
            if !isPaused {
                if currentChunkIndex < chunks.count - 1 {
                    currentChunkIndex += 1
                } else {
                    completeTraining()
                }
            }
        }
    }

    private func stopTraining() {
        timer?.invalidate()
        chunkTimer?.invalidate()
        timer = nil
        chunkTimer = nil
    }

    private func togglePause() {
        isPaused.toggle()
        if isPaused {
            showPauseMenu = true
        }
    }

    private func completeTraining() {
        stopTraining()
        navigateToResults = true
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    NavigationView {
        ChunkingTrainingView(
            chunkSize: 3,
            speed: .medium,
            duration: 10
        )
    }
}
