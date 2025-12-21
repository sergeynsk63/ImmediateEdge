//
//  IntroductionSlidesView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct IntroductionSlidesView: View {
    @State private var currentSlide = 0

    let slides = [
        IntroSlide(
            title: "onboardingSlide1Title",
            description: "onboardingSlide1Description",
            icon: "bolt.circle.fill",
            color: Color.blue
        ),
        IntroSlide(
            title: "onboardingSlide2Title",
            description: "onboardingSlide2Description",
            icon: "brain.head.profile",
            color: Color.purple
        ),
        IntroSlide(
            title: "onboardingSlide3Title",
            description: "onboardingSlide3Description",
            icon: "chart.line.uptrend.xyaxis",
            color: Color.green
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Slides
            TabView(selection: $currentSlide) {
                ForEach(0..<slides.count, id: \.self) { index in
                    SlideView(slide: slides[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            // Bottom Section
            VStack(spacing: DesignSystem.Spacing.large) {
                // Page Indicator
                HStack(spacing: DesignSystem.Spacing.small) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(currentSlide == index ?
                                  DesignSystem.Colors.primary :
                                  DesignSystem.Colors.textSecondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentSlide)
                    }
                }

                // Navigation Buttons
                HStack(spacing: DesignSystem.Spacing.medium) {
                    if currentSlide > 0 {
                        SecondaryButton(title: "back".localized) {
                            withAnimation {
                                currentSlide -= 1
                            }
                        }
                    }

                    if currentSlide == slides.count - 1 {
                        // Last slide - navigate to test
                        NavigationLink(destination: InitialTestView()) {
                            Text("buttonDiscoverSpeed".localized)
                                .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(DesignSystem.Colors.primary)
                                .cornerRadius(DesignSystem.CornerRadius.medium)
                        }
                    } else {
                        // Not last slide - go to next
                        PrimaryButton(
                            title: "next".localized,
                            action: {
                                withAnimation {
                                    currentSlide += 1
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.large)

                // Skip Button
                if currentSlide < slides.count - 1 {
                    NavigationLink(destination: InitialTestView()) {
                        Text("skip".localized)
                            .font(.system(size: DesignSystem.Typography.body))
                            .foregroundColor(DesignSystem.Colors.textSecondary)
                    }
                }
            }
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct IntroSlide {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct SlideView: View {
    let slide: IntroSlide

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.extraLarge) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(slide.color)
                    .frame(width: 150, height: 150)
                    .shadow(radius: 20, y: 10)

                Image(systemName: slide.icon)
                    .font(.system(size: 70))
                    .foregroundColor(.white)
            }

            // Text Content
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text(slide.title.localized)
                    .font(.system(size: DesignSystem.Typography.largeTitle, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(slide.description.localized)
                    .font(.system(size: DesignSystem.Typography.title3))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.extraLarge)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        IntroductionSlidesView()
    }
}
