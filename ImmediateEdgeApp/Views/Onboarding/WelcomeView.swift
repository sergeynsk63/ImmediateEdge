//
//  WelcomeView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Modern background with subtle gradient
                DesignSystem.Colors.background
                    .ignoresSafeArea()

                // Decorative circles
                Circle()
                    .fill(DesignSystem.Colors.primary.opacity(0.12))
                    .frame(width: 300, height: 300)
                    .blur(radius: 60)
                    .offset(x: -100, y: -200)

                Circle()
                    .fill(DesignSystem.Colors.accent.opacity(0.12))
                    .frame(width: 250, height: 250)
                    .blur(radius: 60)
                    .offset(x: 150, y: 300)

                VStack(spacing: DesignSystem.Spacing.extraLarge) {
                    Spacer()

                    // App Logo/Icon
                    ZStack {
                        Circle()
                            .fill(DesignSystem.Colors.primary)
                            .frame(width: 140, height: 140)

                        Image(systemName: "bolt.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                    }
                    .shadow(radius: 20, y: 10)

                    // Title and Subtitle
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        Text("onboardingWelcomeTitle".localized)
                            .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .multilineTextAlignment(.center)

                        Text("onboardingWelcomeSubtitle".localized)
                            .font(.system(size: DesignSystem.Typography.title3))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DesignSystem.Spacing.extraLarge)
                    }

                    Spacer()

                    // Get Started Button
                    NavigationLink(destination: IntroductionSlidesView()) {
                        HStack(spacing: 12) {
                            Text("buttonBeginJourney".localized)
                                .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(DesignSystem.Colors.primary)
                        .cornerRadius(DesignSystem.CornerRadius.medium)
                        .shadow(
                            color: DesignSystem.Colors.primary.opacity(0.4),
                            radius: 12,
                            y: 6
                        )
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)

                    Spacer()
                        .frame(height: 40)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                // Setup language automatically on first launch
                LanguageManager.shared.setupInitialLanguage()
            }
        }
        .navigationViewStyle(.stack)
    }
}

// Bundle extension for version
extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}

#Preview {
    WelcomeView()
}
