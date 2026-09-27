//
//  GlassCard.swift
//  LockScreen Studio
//

import SwiftUI

struct GlassCard<Content: View>: View {
    var cornerRadius: CGFloat = 16
    var opacity: Double = 0.25
    var borderColor: Color = Color.white.opacity(0.3)
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding()
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(opacity))
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: 0.8)
            }
    }
}

#Preview("GlassCard") {
    ZStack {
        LinearGradient(colors: [.orange, .pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text("GlassCard Component")
                    .font(.headline)
                Text("Provides smooth ultra-thin material frosted glass container with custom border and shadow.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 260)
        }
    }
    .frame(width: 360, height: 200)
}
