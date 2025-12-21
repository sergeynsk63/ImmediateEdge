//
//  PrimaryButton.swift
//  ImmediateEdgeApp
//
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var icon: String? = nil

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: DesignSystem.Typography.headline, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                isEnabled ? DesignSystem.Colors.primary : DesignSystem.Colors.textSecondary
            )
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .shadow(
                color: isEnabled ? DesignSystem.Colors.primary.opacity(0.3) : Color.clear,
                radius: 8,
                y: 4
            )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var icon: String? = nil

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(.system(size: DesignSystem.Typography.headline, weight: .medium))
            }
            .foregroundColor(DesignSystem.Colors.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(DesignSystem.Colors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.Colors.primary, lineWidth: 2)
            )
            .cornerRadius(DesignSystem.CornerRadius.medium)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Primary Button") {
            print("Primary tapped")
        }

        PrimaryButton(title: "Disabled", action: {}, isEnabled: false)

        SecondaryButton(title: "Secondary Button") {
            print("Secondary tapped")
        }
    }
    .padding()
}
