//
//  WidgetConfiguration.swift
//  LockScreen Studio
//

import SwiftUI

enum WidgetPosition: String, Codable, CaseIterable, Identifiable {
    case topBelowClock = "Below Clock"
    case leftSidebar = "Left Column"
    case rightSidebar = "Right Column"
    case bottomRow = "Bottom Dock Area"

    var id: String { rawValue }
}

enum WidgetStyle: String, Codable, CaseIterable, Identifiable {
    case glass = "Frosted Glass"
    case ultraThin = "Ultra-Thin Glass"
    case solid = "Dark Solid"
    case subtleOutline = "Minimalist Border"

    var id: String { rawValue }
}

struct WidgetConfiguration: Codable, Hashable, Equatable {
    var showWeather: Bool = true
    var showBattery: Bool = true
    var showCalendar: Bool = true
    var showSystemInfo: Bool = true

    var position: WidgetPosition = .topBelowClock
    var style: WidgetStyle = .glass
    var accentColor: CodableColor = .cyan
    var cornerRadius: Double = 14.0
    var opacity: Double = 0.85

    // Custom mock values for preview customization
    var weatherCity: String = "Cupertino"
    var weatherTemperature: Int = 72
    var weatherCondition: String = "Sunny"

    var batteryPercentage: Int = 94
    var batteryCharging: Bool = true

    var calendarEventTitle: String = "Design Review with Team"
    var calendarEventTime: String = "4:00 PM"

    static var defaultConfiguration: WidgetConfiguration {
        WidgetConfiguration()
    }
}
