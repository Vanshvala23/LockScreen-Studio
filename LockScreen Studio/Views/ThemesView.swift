//
//  ThemesView.swift
//  LockScreen Studio
//

import SwiftUI
import SwiftData

struct ThemesView: View {
    @Bindable var store: ThemeEditorStore
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\LockScreenTheme.createdAt, order: .reverse)]) private var savedThemes: [LockScreenTheme]

    @State private var themeToRename: LockScreenTheme? = nil
    @State private var renameText: String = ""

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Header & Save Current Button
                InspectorSection(title: "Save & Export", iconName: "bookmark") {
                    VStack(spacing: 10) {
                        Button {
                            saveCurrentTheme()
                        } label: {
                            Label("Save Active Theme to Library", systemImage: "plus.circle.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                // Saved Themes Section (SwiftData)
                InspectorSection(title: "Saved Library Themes", iconName: "tray.full", badge: "\(savedThemes.count)") {
                    if savedThemes.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "folder.badge.questionmark")
                                .font(.system(size: 24))
                                .foregroundStyle(.secondary)
                            Text("No saved themes yet")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(savedThemes) { theme in
                                themeCardView(theme: theme, isPreset: false)
                            }
                        }
                    }
                }

                // Built-in Presets Section
                InspectorSection(title: "Built-In Presets", iconName: "sparkles", badge: "\(PresetThemes.presets.count)") {
                    VStack(spacing: 8) {
                        ForEach(PresetThemes.presets) { preset in
                            themeCardView(theme: preset, isPreset: true)
                        }
                    }
                }
            }
            .padding(14)
        }
        .sheet(item: $themeToRename) { theme in
            renameThemeSheet(theme: theme)
        }
    }

    // MARK: - Theme Card Item

    @ViewBuilder
    private func themeCardView(theme: LockScreenTheme, isPreset: Bool) -> some View {
        let isSelected = store.activeTheme.id == theme.id

        HStack(spacing: 10) {
            // Thumbnail
            RoundedRectangle(cornerRadius: 8)
                .fill(LinearGradient(
                    colors: theme.wallpaperConfig.gradientPreset.colors.map { $0.color },
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 48, height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(theme.name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(isPreset ? "Built-in Preset" : theme.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Menu {
                Button {
                    withAnimation {
                        store.loadTheme(theme)
                    }
                } label: {
                    Label("Apply Theme", systemImage: "checkmark.circle")
                }

                Button {
                    store.selectPreset(theme)
                } label: {
                    Label("Duplicate as Copy", systemImage: "doc.on.doc")
                }

                if !isPreset {
                    Button {
                        renameText = theme.name
                        themeToRename = theme
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }

                    Divider()

                    Button(role: .destructive) {
                        deleteTheme(theme)
                    } label: {
                        Label("Delete Theme", systemImage: "trash")
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .menuStyle(.borderlessButton)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.accentColor.opacity(0.12) : Color.primary.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 1.5)
        )
        .onTapGesture {
            withAnimation {
                store.loadTheme(theme)
            }
        }
    }

    // MARK: - Rename Sheet

    @ViewBuilder
    private func renameThemeSheet(theme: LockScreenTheme) -> some View {
        VStack(spacing: 16) {
            Text("Rename Theme")
                .font(.system(size: 14, weight: .bold))

            TextField("Theme Name", text: $renameText)
                .textFieldStyle(.roundedBorder)

            HStack {
                Button("Cancel") {
                    themeToRename = nil
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Save") {
                    theme.name = renameText
                    try? modelContext.save()
                    themeToRename = nil
                    store.showToast("Theme renamed")
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 300)
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
        store.showToast("Saved theme: \(newTheme.name)")
    }

    private func deleteTheme(_ theme: LockScreenTheme) {
        modelContext.delete(theme)
        try? modelContext.save()
        store.showToast("Deleted theme")
    }
}

#Preview("Themes Library Inspector View") {
    ThemesView(store: ThemeEditorStore())
        .modelContainer(for: LockScreenTheme.self, inMemory: true)
        .frame(width: 320, height: 600)
}
