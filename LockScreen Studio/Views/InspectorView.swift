//
//  InspectorView.swift
//  LockScreen Studio
//

import SwiftUI

struct InspectorView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        VStack(spacing: 0) {
            // Inspector Header Title
            HStack {
                Label(store.selectedSection.rawValue, systemImage: store.selectedSection.iconName)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Material.bar)

            Divider()

            // Inspector Section Body
            Group {
                switch store.selectedSection {
                case .overview:
                    OverviewInspectorView(store: store)
                case .wallpaper:
                    WallpaperView(store: store)
                case .clock:
                    ClockView(store: store)
                case .widgets:
                    WidgetsView(store: store)
                case .effects:
                    EffectsView(store: store)
                case .themes:
                    ThemesView(store: store)
                case .settings:
                    SettingsView(store: store)
                }
            }
        }
        .frame(minWidth: 280, idealWidth: 320, maxWidth: 380)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

#Preview("Inspector Router") {
    InspectorView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
