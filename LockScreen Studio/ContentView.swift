//
//  ContentView.swift
//  LockScreen Studio
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var store = ThemeEditorStore()

    var body: some View {
        NavigationSplitView {
            SidebarView(store: store)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 240)
        } detail: {
            HStack(spacing: 0) {
                PreviewView(store: store)

                Divider()

                InspectorView(store: store)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    store.resetToDefaults()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .help("Reset current draft to default settings")

                Button {
                    store.createNewTheme()
                } label: {
                    Label("New Theme", systemImage: "plus")
                }
                .help("Create a new theme draft")
            }
        }
        .frame(minWidth: 960, minHeight: 640)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LockScreenTheme.self, inMemory: true)
}
