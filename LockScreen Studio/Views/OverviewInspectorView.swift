//
//  OverviewInspectorView.swift
//  LockScreen Studio
//

import SwiftUI
import SwiftData

struct OverviewInspectorView: View {
    @Bindable var store: ThemeEditorStore
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Theme Name Header Card
                InspectorSection(title: "Theme Title", iconName: "square.and.pencil") {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Theme Name", text: $store.activeTheme.name)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 13, weight: .medium))

                        HStack {
                            Text("Created: \(store.activeTheme.createdAt, format: Date.FormatStyle(date: .numeric, time: .shortened))")
                                .font(.system(size: 10))
                                .foregroundStyle(.secondary)

                            Spacer()

                            if store.activeTheme.isPreset {
                                Text("Preset")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.orange)
                            }
                        }
                    }
                }

                // Quick Preset Selector
                InspectorSection(title: "Quick Presets", iconName: "sparkles", badge: "\(PresetThemes.presets.count)") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(PresetThemes.presets) { preset in
                                Button {
                                    withAnimation(.smooth) {
                                        store.selectPreset(preset)
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(LinearGradient(
                                                colors: preset.wallpaperConfig.gradientPreset.colors.map { $0.color },
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                            .frame(width: 64, height: 40)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                                            )

                                        Text(preset.name)
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundStyle(.primary)
                                            .lineLimit(1)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                // Configuration Summary
                InspectorSection(title: "Active Elements", iconName: "slider.horizontal.3") {
                    VStack(spacing: 8) {
                        SummaryRowView(
                            icon: "photo.on.rectangle",
                            title: "Wallpaper",
                            detail: store.activeTheme.wallpaperConfig.type.rawValue,
                            color: .blue
                        )
                        SummaryRowView(
                            icon: "clock",
                            title: "Clock Style",
                            detail: store.activeTheme.clockConfig.style.rawValue,
                            color: .purple
                        )
                        SummaryRowView(
                            icon: "square.stack.3d.up",
                            title: "Widgets",
                            detail: "\(activeWidgetsCount) Enabled",
                            color: .green
                        )
                        SummaryRowView(
                            icon: "wand.and.stars",
                            title: "Effects",
                            detail: store.activeTheme.effectsConfig.vignette > 0 ? "Vignette On" : "Clean",
                            color: .orange
                        )
                    }
                }

                // Quick Actions
                InspectorSection(title: "Actions", iconName: "bolt") {
                    VStack(spacing: 8) {
                        Button {
                            saveCurrentTheme()
                        } label: {
                            Label("Save Theme to Library", systemImage: "square.and.arrow.down")
                                .font(.system(size: 12, weight: .semibold))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        HStack(spacing: 8) {
                            Button {
                                store.resetToDefaults()
                            } label: {
                                Label("Reset All", systemImage: "arrow.counterclockwise")
                                    .font(.system(size: 11))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)

                            Button {
                                store.createNewTheme()
                            } label: {
                                Label("New Theme", systemImage: "plus")
                                    .font(.system(size: 11))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .padding(14)
        }
    }

    private var activeWidgetsCount: Int {
        let w = store.activeTheme.widgetConfig
        return [w.showWeather, w.showBattery, w.showCalendar, w.showSystemInfo].filter { $0 }.count
    }

    private func saveCurrentTheme() {
        let newTheme = LockScreenTheme(
            id: UUID(),
            name: store.activeTheme.name,
            createdAt: Date(),
            isPreset: false,
            wallpaperConfig: store.activeTheme.wallpaperConfig,
            clockConfig: store.activeTheme.clockConfig,
            widgetConfig: store.activeTheme.widgetConfig,
            effectsConfig: store.activeTheme.effectsConfig
        )
        modelContext.insert(newTheme)
        try? modelContext.save()
        store.showToast("Saved theme to Library!")
    }
}

struct SummaryRowView: View {
    let icon: String
    let title: String
    let detail: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(color)
                .frame(width: 18)

            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(.primary)

            Spacer()

            Text(detail)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(RoundedRectangle(cornerRadius: 6).fill(Color.primary.opacity(0.03)))
    }
}

#Preview("Overview Inspector") {
    OverviewInspectorView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
