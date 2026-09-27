//
//  ThemeEditorStore.swift
//  LockScreen Studio
//

import SwiftUI
import SwiftData
import AppKit

enum SidebarSection: String, CaseIterable, Identifiable {
    case overview = "Overview"
    case wallpaper = "Wallpaper"
    case clock = "Clock"
    case widgets = "Widgets"
    case effects = "Effects"
    case themes = "Themes"
    case settings = "Settings"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .overview: return "square.grid.2x2"
        case .wallpaper: return "photo.on.rectangle"
        case .clock: return "clock"
        case .widgets: return "square.stack.3d.up"
        case .effects: return "wand.and.stars"
        case .themes: return "swatchpalette"
        case .settings: return "gearshape"
        }
    }
}

enum HardwareFrameMode: String, CaseIterable, Identifiable {
    case macbookPro = "MacBook Pro"
    case studioDisplay = "Studio Display"
    case frameless = "Frameless Screen"

    var id: String { rawValue }
}

enum PreviewAspectRatio: String, CaseIterable, Identifiable {
    case sixteenTen = "16:10 (MacBook)"
    case sixteenNine = "16:9 (Display)"
    case fourThree = "4:3 (Classic)"

    var id: String { rawValue }

    var ratio: CGFloat {
        switch self {
        case .sixteenTen: return 16.0 / 10.0
        case .sixteenNine: return 16.0 / 9.0
        case .fourThree: return 4.0 / 3.0
        }
    }
}

@Observable
final class ThemeEditorStore {
    var selectedSection: SidebarSection = .overview

    // Current draft theme being edited in real-time
    var activeTheme: LockScreenTheme

    // Preview options
    var hardwareFrame: HardwareFrameMode = .macbookPro
    var aspectRatio: PreviewAspectRatio = .sixteenTen
    var isFullPreviewPresented: Bool = false
    var zoomLevel: Double = 1.0

    // Custom image state
    var loadedCustomImage: NSImage? = nil

    // Notification toast
    var toastMessage: String? = nil

    init(theme: LockScreenTheme? = nil) {
        if let theme {
            self.activeTheme = theme
        } else if let firstPreset = PresetThemes.presets.first {
            self.activeTheme = firstPreset
        } else {
            self.activeTheme = LockScreenTheme()
        }
    }

    func selectPreset(_ preset: LockScreenTheme) {
        self.activeTheme = LockScreenTheme(
            id: UUID(),
            name: "\(preset.name) (Copy)",
            createdAt: Date(),
            isPreset: false,
            wallpaperConfig: preset.wallpaperConfig,
            clockConfig: preset.clockConfig,
            widgetConfig: preset.widgetConfig,
            effectsConfig: preset.effectsConfig
        )
        showToast("Loaded \(preset.name)")
    }

    func loadTheme(_ theme: LockScreenTheme) {
        self.activeTheme = theme
        showToast("Applied theme: \(theme.name)")
    }

    func createNewTheme() {
        self.activeTheme = LockScreenTheme(
            id: UUID(),
            name: "New Theme",
            createdAt: Date(),
            isPreset: false,
            wallpaperConfig: .defaultConfiguration,
            clockConfig: .defaultConfiguration,
            widgetConfig: .defaultConfiguration,
            effectsConfig: .defaultConfiguration
        )
        showToast("Created new theme")
    }

    func resetToDefaults() {
        self.activeTheme.wallpaperConfig = .defaultConfiguration
        self.activeTheme.clockConfig = .defaultConfiguration
        self.activeTheme.widgetConfig = .defaultConfiguration
        self.activeTheme.effectsConfig = .defaultConfiguration
        showToast("Reset settings to default")
    }

    func showToast(_ message: String) {
        self.toastMessage = message
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2.5))
            if self.toastMessage == message {
                self.toastMessage = nil
            }
        }
    }
}
