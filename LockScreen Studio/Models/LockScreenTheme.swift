//
//  LockScreenTheme.swift
//  LockScreen Studio
//

import Foundation
import SwiftData

@Model
final class LockScreenTheme {
    var id: UUID
    var name: String
    var createdAt: Date
    var isPreset: Bool

    var wallpaperConfig: WallpaperConfiguration
    var clockConfig: ClockConfiguration
    var widgetConfig: WidgetConfiguration
    var effectsConfig: EffectsConfiguration

    init(
        id: UUID = UUID(),
        name: String = "Untitled Theme",
        createdAt: Date = Date(),
        isPreset: Bool = false,
        wallpaperConfig: WallpaperConfiguration = .defaultConfiguration,
        clockConfig: ClockConfiguration = .defaultConfiguration,
        widgetConfig: WidgetConfiguration = .defaultConfiguration,
        effectsConfig: EffectsConfiguration = .defaultConfiguration
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.isPreset = isPreset
        self.wallpaperConfig = wallpaperConfig
        self.clockConfig = clockConfig
        self.widgetConfig = widgetConfig
        self.effectsConfig = effectsConfig
    }
}
