//
//  WallpaperConfiguration.swift
//  LockScreen Studio
//

import SwiftUI

enum WallpaperType: String, Codable, CaseIterable, Identifiable {
    case gradient = "Gradient Preset"
    case solidColor = "Solid Color"
    case customImage = "Custom Image"

    var id: String { rawValue }
}

enum ScaleMode: String, Codable, CaseIterable, Identifiable {
    case fill = "Aspect Fill"
    case fit = "Aspect Fit"
    case stretch = "Stretch"
    case custom = "Custom Zoom & Pan"

    var id: String { rawValue }
}

enum GradientPreset: String, Codable, CaseIterable, Identifiable {
    case sonoma = "Sonoma Sunset"
    case monterey = "Monterey Waves"
    case aurora = "Aurora Borealis"
    case midnight = "Cupertino Midnight"
    case cyberpunk = "Neon Cyberpunk"
    case emerald = "Emerald Forest"
    case lavender = "Lavender Mist"
    case solar = "Solar Flare"

    var id: String { rawValue }

    var colors: [CodableColor] {
        switch self {
        case .sonoma:
            return [
                CodableColor(red: 0.95, green: 0.45, blue: 0.25),
                CodableColor(red: 0.85, green: 0.20, blue: 0.45),
                CodableColor(red: 0.35, green: 0.15, blue: 0.60)
            ]
        case .monterey:
            return [
                CodableColor(red: 0.15, green: 0.35, blue: 0.85),
                CodableColor(red: 0.55, green: 0.25, blue: 0.75),
                CodableColor(red: 0.90, green: 0.35, blue: 0.55)
            ]
        case .aurora:
            return [
                CodableColor(red: 0.05, green: 0.25, blue: 0.35),
                CodableColor(red: 0.15, green: 0.75, blue: 0.55),
                CodableColor(red: 0.45, green: 0.20, blue: 0.80)
            ]
        case .midnight:
            return [
                CodableColor(red: 0.05, green: 0.08, blue: 0.18),
                CodableColor(red: 0.12, green: 0.18, blue: 0.32),
                CodableColor(red: 0.02, green: 0.04, blue: 0.10)
            ]
        case .cyberpunk:
            return [
                CodableColor(red: 0.95, green: 0.05, blue: 0.55),
                CodableColor(red: 0.10, green: 0.05, blue: 0.25),
                CodableColor(red: 0.05, green: 0.85, blue: 0.95)
            ]
        case .emerald:
            return [
                CodableColor(red: 0.05, green: 0.25, blue: 0.20),
                CodableColor(red: 0.15, green: 0.55, blue: 0.40),
                CodableColor(red: 0.02, green: 0.15, blue: 0.10)
            ]
        case .lavender:
            return [
                CodableColor(red: 0.85, green: 0.80, blue: 0.95),
                CodableColor(red: 0.65, green: 0.60, blue: 0.85),
                CodableColor(red: 0.45, green: 0.40, blue: 0.70)
            ]
        case .solar:
            return [
                CodableColor(red: 1.00, green: 0.75, blue: 0.15),
                CodableColor(red: 0.95, green: 0.35, blue: 0.10),
                CodableColor(red: 0.75, green: 0.10, blue: 0.20)
            ]
        }
    }
}

struct WallpaperConfiguration: Codable, Hashable, Equatable {
    var type: WallpaperType = .gradient
    var gradientPreset: GradientPreset = .sonoma
    var solidColor: CodableColor = CodableColor(red: 0.12, green: 0.15, blue: 0.25)
    var customImagePath: String? = nil
    var customImageData: Data? = nil

    // Adjustments
    var brightness: Double = 0.0      // -0.5 to 0.5
    var blur: Double = 0.0            // 0 to 30
    var saturation: Double = 1.0      // 0 to 2.0
    var contrast: Double = 1.0        // 0.5 to 1.5
    var opacity: Double = 1.0         // 0 to 1.0

    // Scaling & Cropping
    var scaleMode: ScaleMode = .fill
    var zoomScale: Double = 1.0       // 0.5 to 3.0
    var offsetX: Double = 0.0         // -200 to 200
    var offsetY: Double = 0.0         // -200 to 200

    static var defaultConfiguration: WallpaperConfiguration {
        WallpaperConfiguration()
    }
}
