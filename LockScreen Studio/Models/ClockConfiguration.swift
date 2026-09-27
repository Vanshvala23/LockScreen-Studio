//
//  ClockConfiguration.swift
//  LockScreen Studio
//

import SwiftUI

enum ClockStyle: String, Codable, CaseIterable, Identifiable {
    case digitalStandard = "Standard Digital"
    case digitalMinimal = "Minimalist"
    case digitalBold = "Bold Modern"
    case digitalCompact = "Compact Header"
    case typographyHero = "Typography Hero"
    case liquidGlassHUD = "Liquid Glass HUD"
    case retroFlip = "Retro Flip Card"
    case analogClassic = "Analog Clock"

    var id: String { rawValue }
}

enum ClockFontDesign: String, Codable, CaseIterable, Identifiable {
    case system = "System Default"
    case serif = "Serif"
    case monospaced = "Monospaced"
    case rounded = "Rounded"

    var id: String { rawValue }

    var fontDesign: Font.Design {
        switch self {
        case .system: return .default
        case .serif: return .serif
        case .monospaced: return .monospaced
        case .rounded: return .rounded
        }
    }
}

enum ClockFontWeight: String, Codable, CaseIterable, Identifiable {
    case ultraLight = "Ultra Light"
    case thin = "Thin"
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
    case bold = "Bold"
    case heavy = "Heavy"

    var id: String { rawValue }

    var fontWeight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        }
    }
}

enum ClockPosition: String, Codable, CaseIterable, Identifiable {
    case topCenter = "Top Center"
    case center = "Center"
    case topLeft = "Top Left"
    case topRight = "Top Right"
    case custom = "Custom Position"

    var id: String { rawValue }
}

enum ClockDateStyle: String, Codable, CaseIterable, Identifiable {
    case full = "Full (Monday, September 27)"
    case medium = "Medium (Mon, Sep 27)"
    case short = "Numeric (09/27/2026)"
    case uppercase = "Uppercase (SEP 27)"

    var id: String { rawValue }
}

struct ClockConfiguration: Codable, Hashable, Equatable {
    var style: ClockStyle = .digitalBold
    var fontDesign: ClockFontDesign = .rounded
    var fontSize: Double = 76.0
    var fontWeight: ClockFontWeight = .semibold
    var textColor: CodableColor = .white
    var opacity: Double = 0.95
    var position: ClockPosition = .topCenter
    var customOffsetX: Double = 0.0
    var customOffsetY: Double = 0.0

    // Time & Date format
    var is24Hour: Bool = false
    var showSeconds: Bool = false
    var showDate: Bool = true
    var dateStyle: ClockDateStyle = .full
    var isLiveTime: Bool = true

    static var defaultConfiguration: ClockConfiguration {
        ClockConfiguration()
    }
}
