//
//  ProfileView.swift
//  ImmediateEdgeApp
//
//

import SwiftUI
import SafariServices
import Combine
import WebKit

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingShareSheet = false
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignSystem.Spacing.large) {
                    // User Profile Header
                    VStack(spacing: DesignSystem.Spacing.small) {
                        // Avatar Circle
                        Circle()
                            .fill(DesignSystem.Colors.primary)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(viewModel.userInitials)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            )

                        Text(viewModel.username)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)

                        if let memberSince = viewModel.memberSinceText {
                            Text(memberSince)
                                .font(.system(size: DesignSystem.Typography.subhead))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.medium)

                    // Results Summary Card
                    ResultsSummaryCard(
                        currentSpeed: viewModel.currentSpeed,
                        totalSessions: viewModel.totalSessions,
                        currentStreak: viewModel.currentStreak,
                        totalWords: viewModel.totalWordsRead
                    )

                    // Share Results Button
                    Button(action: { showingShareSheet = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Share My Results")
                                .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(DesignSystem.Colors.accent)
                        .cornerRadius(DesignSystem.CornerRadius.medium)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showingShareSheet) {
                        ShareSheet(items: [viewModel.shareText])
                    }

                    // Legal Section
                    VStack(spacing: DesignSystem.Spacing.small) {
                        Text("Legal")
                            .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        VStack(spacing: 1) {
                            LegalButton(
                                title: "Privacy Policy",
                                icon: "lock.shield.fill"
                            ) {
                                showingPrivacyPolicy = true
                            }

                            Divider()
                                .padding(.horizontal)

                            LegalButton(
                                title: "Terms of Service",
                                icon: "doc.text.fill"
                            ) {
                                showingTermsOfService = true
                            }
                        }
                        .background(DesignSystem.Colors.cardBackground)
                        .cornerRadius(DesignSystem.CornerRadius.medium)
                        .padding(.horizontal)
                    }

                    // App Info
                    VStack(spacing: DesignSystem.Spacing.extraSmall) {
                        Text("Immediate Edge")
                            .font(.system(size: DesignSystem.Typography.subhead, weight: .semibold))
                            .foregroundColor(DesignSystem.Colors.textSecondary)

                        if let version = viewModel.appVersion {
                            Text("Version \(version)")
                                .font(.system(size: DesignSystem.Typography.caption))
                                .foregroundColor(DesignSystem.Colors.textSecondary)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.medium)
                    .padding(.bottom, DesignSystem.Spacing.extraLarge)
                }
            }
            .background(DesignSystem.Colors.background.ignoresSafeArea())
            .navigationTitle("profileTitle".localized)
            .sheet(isPresented: $showingPrivacyPolicy) {
                WebViewSheet(
                    url: URL(string: AppConstants.privacyPolicyURL)!,
                    title: "Privacy Policy"
                )
            }
            .sheet(isPresented: $showingTermsOfService) {
                WebViewSheet(
                    url: URL(string: AppConstants.termsOfServiceURL)!,
                    title: "Terms of Service"
                )
            }
        }
    }
}

// MARK: - Results Summary Card
struct ResultsSummaryCard: View {
    let currentSpeed: Int
    let totalSessions: Int
    let currentStreak: Int
    let totalWords: Int

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            Text("My Achievements")
                .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
                .foregroundColor(DesignSystem.Colors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Stats Grid
            VStack(spacing: DesignSystem.Spacing.small) {
                HStack(spacing: DesignSystem.Spacing.small) {
                    StatBox(
                        value: "\(currentSpeed)",
                        label: "WPM",
                        icon: "speedometer",
                        color: DesignSystem.Colors.primary
                    )

                    StatBox(
                        value: "\(totalSessions)",
                        label: "Sessions",
                        icon: "checkmark.circle.fill",
                        color: DesignSystem.Colors.secondary
                    )
                }

                HStack(spacing: DesignSystem.Spacing.small) {
                    StatBox(
                        value: "\(currentStreak)",
                        label: "Day Streak",
                        icon: "flame.fill",
                        color: DesignSystem.Colors.accent
                    )

                    StatBox(
                        value: "\(totalWords / 1000)k",
                        label: "Words Read",
                        icon: "book.fill",
                        color: DesignSystem.Colors.rsvpColor
                    )
                }
            }
        }
        .padding()
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.CornerRadius.large)
        .padding(.horizontal)
    }
}

// MARK: - Stat Box
struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: DesignSystem.Spacing.small) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(DesignSystem.Colors.textPrimary)

            Text(label)
                .font(.system(size: DesignSystem.Typography.caption))
                .foregroundColor(DesignSystem.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(DesignSystem.Colors.secondaryBackground)
        .cornerRadius(DesignSystem.CornerRadius.medium)
    }
}

// MARK: - Legal Button
struct LegalButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(width: 24)

                Text(title)
                    .font(.system(size: DesignSystem.Typography.body))
                    .foregroundColor(DesignSystem.Colors.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(DesignSystem.Colors.textSecondary)
            }
            .padding()
        }
    }
}

// MARK: - WebView Sheet
struct WebViewSheet: View {
    let url: URL
    let title: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            WebView(url: url)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

// MARK: - WebView
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ProfileView()
}
