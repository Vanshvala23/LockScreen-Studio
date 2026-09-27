//
//  PresetThemes.swift
//  LockScreen Studio
//

import Foundation
import SwiftUI

struct PresetThemes {
    static var presets: [LockScreenTheme] {
        [
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000000") ?? UUID(),
                name: "Liquid Glass Glow",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .gradient,
                    gradientPreset: .aurora,
                    brightness: 0.05,
                    blur: 3.0,
                    saturation: 1.3,
                    contrast: 1.1
                ),
                clockConfig: ClockConfiguration(
                    style: .liquidGlassHUD,
                    fontDesign: .rounded,
                    fontSize: 82.0,
                    fontWeight: .bold,
                    textColor: .white,
                    opacity: 1.0,
                    position: .topCenter,
                    is24Hour: false,
                    showSeconds: true,
                    showDate: true,
                    dateStyle: .full
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: true,
                    showBattery: true,
                    showCalendar: true,
                    showSystemInfo: true,
                    position: .topBelowClock,
                    style: .glass,
                    accentColor: .cyan
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.18,
                    filmGrain: 0.0,
                    colorTintEnabled: true,
                    colorTint: CodableColor(red: 0.0, green: 0.6, blue: 0.9),
                    tintIntensity: 0.12,
                    dimmingLevel: 0.08
                )
            ),
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001") ?? UUID(),
                name: "Sonoma Sunset",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .gradient,
                    gradientPreset: .sonoma,
                    brightness: 0.05,
                    blur: 0.0,
                    saturation: 1.15,
                    contrast: 1.05
                ),
                clockConfig: ClockConfiguration(
                    style: .digitalBold,
                    fontDesign: .rounded,
                    fontSize: 84.0,
                    fontWeight: .bold,
                    textColor: .white,
                    opacity: 0.95,
                    position: .topCenter,
                    is24Hour: false,
                    showDate: true,
                    dateStyle: .full
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: true,
                    showBattery: true,
                    showCalendar: true,
                    showSystemInfo: true,
                    position: .topBelowClock,
                    style: .glass,
                    accentColor: .white
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.20,
                    dimmingLevel: 0.10
                )
            ),
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002") ?? UUID(),
                name: "Cupertino Midnight",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .gradient,
                    gradientPreset: .midnight,
                    brightness: -0.05,
                    blur: 0.0,
                    saturation: 1.0,
                    contrast: 1.1
                ),
                clockConfig: ClockConfiguration(
                    style: .digitalMinimal,
                    fontDesign: .monospaced,
                    fontSize: 72.0,
                    fontWeight: .light,
                    textColor: CodableColor(red: 0.70, green: 0.85, blue: 1.0),
                    opacity: 0.90,
                    position: .topCenter,
                    is24Hour: true,
                    showDate: true,
                    dateStyle: .medium
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: true,
                    showBattery: true,
                    showCalendar: false,
                    showSystemInfo: true,
                    position: .topBelowClock,
                    style: .ultraThin,
                    accentColor: .cyan
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.35,
                    dimmingLevel: 0.15
                )
            ),
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003") ?? UUID(),
                name: "Aurora Borealis",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .gradient,
                    gradientPreset: .aurora,
                    brightness: 0.0,
                    blur: 2.0,
                    saturation: 1.2,
                    contrast: 1.0
                ),
                clockConfig: ClockConfiguration(
                    style: .typographyHero,
                    fontDesign: .serif,
                    fontSize: 90.0,
                    fontWeight: .regular,
                    textColor: CodableColor(red: 0.85, green: 1.0, blue: 0.90),
                    opacity: 1.0,
                    position: .topCenter,
                    is24Hour: false,
                    showDate: true,
                    dateStyle: .uppercase
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: true,
                    showBattery: true,
                    showCalendar: true,
                    showSystemInfo: false,
                    position: .leftSidebar,
                    style: .glass,
                    accentColor: .green
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.25,
                    filmGrain: 0.10,
                    dimmingLevel: 0.08
                )
            ),
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004") ?? UUID(),
                name: "Neon Cyberpunk",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .gradient,
                    gradientPreset: .cyberpunk,
                    brightness: 0.10,
                    blur: 0.0,
                    saturation: 1.5,
                    contrast: 1.25
                ),
                clockConfig: ClockConfiguration(
                    style: .digitalBold,
                    fontDesign: .monospaced,
                    fontSize: 80.0,
                    fontWeight: .heavy,
                    textColor: CodableColor(red: 1.0, green: 0.20, blue: 0.65),
                    opacity: 1.0,
                    position: .topCenter,
                    is24Hour: true,
                    showSeconds: true,
                    showDate: true,
                    dateStyle: .uppercase
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: true,
                    showBattery: true,
                    showCalendar: true,
                    showSystemInfo: true,
                    position: .bottomRow,
                    style: .subtleOutline,
                    accentColor: .pink
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.40,
                    filmGrain: 0.15,
                    dimmingLevel: 0.12,
                    crtScanlines: true
                )
            ),
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005") ?? UUID(),
                name: "Minimalist Studio",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .solidColor,
                    solidColor: CodableColor(red: 0.12, green: 0.14, blue: 0.18),
                    brightness: 0.0,
                    blur: 0.0,
                    saturation: 1.0,
                    contrast: 1.0
                ),
                clockConfig: ClockConfiguration(
                    style: .digitalMinimal,
                    fontDesign: .system,
                    fontSize: 78.0,
                    fontWeight: .ultraLight,
                    textColor: .white,
                    opacity: 0.85,
                    position: .center,
                    is24Hour: false,
                    showDate: true,
                    dateStyle: .medium
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: false,
                    showBattery: true,
                    showCalendar: true,
                    showSystemInfo: false,
                    position: .topBelowClock,
                    style: .ultraThin,
                    accentColor: .white
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.0,
                    dimmingLevel: 0.05
                )
            ),
            LockScreenTheme(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006") ?? UUID(),
                name: "Retro Macintosh",
                createdAt: Date(),
                isPreset: true,
                wallpaperConfig: WallpaperConfiguration(
                    type: .solidColor,
                    solidColor: CodableColor(red: 0.88, green: 0.86, blue: 0.80),
                    brightness: 0.0,
                    blur: 0.0,
                    saturation: 0.8,
                    contrast: 1.1
                ),
                clockConfig: ClockConfiguration(
                    style: .retroFlip,
                    fontDesign: .monospaced,
                    fontSize: 70.0,
                    fontWeight: .bold,
                    textColor: .white,
                    opacity: 1.0,
                    position: .topCenter,
                    is24Hour: false,
                    showDate: true,
                    dateStyle: .short
                ),
                widgetConfig: WidgetConfiguration(
                    showWeather: true,
                    showBattery: true,
                    showCalendar: true,
                    showSystemInfo: true,
                    position: .rightSidebar,
                    style: .solid,
                    accentColor: .orange
                ),
                effectsConfig: EffectsConfiguration(
                    vignette: 0.20,
                    filmGrain: 0.20,
                    dimmingLevel: 0.0,
                    crtScanlines: true
                )
            )
        ]
    }
}
