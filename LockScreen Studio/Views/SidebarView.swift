//
//  SidebarView.swift
//  LockScreen Studio
//

import SwiftUI

struct SidebarView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        List(SidebarSection.allCases, selection: $store.selectedSection) { section in
            NavigationLink(value: section) {
                Label {
                    Text(section.rawValue)
                        .font(.system(size: 13, weight: .medium))
                } icon: {
                    Image(systemName: section.iconName)
                        .font(.system(size: 14))
                        .foregroundStyle(store.selectedSection == section ? Color.accentColor : Color.secondary)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Studio")
    }
}

#Preview("Sidebar View") {
    SidebarView(store: ThemeEditorStore())
        .frame(width: 200, height: 500)
}
