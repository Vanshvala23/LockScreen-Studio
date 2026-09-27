//
//  WidgetCard.swift
//  LockScreen Studio
//

import SwiftUI

struct WidgetContainerView: View {
    let config: WidgetConfiguration

    var body: some View {
        let activeWidgetsCount = [
            config.showWeather,
            config.showBattery,
            config.showCalendar,
            config.showSystemInfo
        ].filter { $0 }.count

        if activeWidgetsCount > 0 {
            widgetLayoutView()
        }
    }

    @ViewBuilder
    private func widgetLayoutView() -> some View {
        switch config.position {
        case .topBelowClock, .bottomRow:
            HStack(spacing: 12) {
                renderActiveWidgets()
            }
        case .leftSidebar, .rightSidebar:
            VStack(alignment: config.position == .leftSidebar ? .leading : .trailing, spacing: 10) {
                renderActiveWidgets()
            }
        }
    }

    @ViewBuilder
    private func renderActiveWidgets() -> some View {
        if config.showWeather {
            WeatherWidgetView(config: config)
        }
        if config.showBattery {
            BatteryWidgetView(config: config)
        }
        if config.showCalendar {
            CalendarWidgetView(config: config)
        }
        if config.showSystemInfo {
            SystemInfoWidgetView(config: config)
        }
    }
}

// MARK: - Weather Widget

struct WeatherWidgetView: View {
    let config: WidgetConfiguration

    var body: some View {
        GlassWidgetCard(config: config) {
            HStack(spacing: 10) {
                Image(systemName: weatherIconName)
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 4) {
                        Text(config.weatherCity)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.primary)

                        Text("\(config.weatherTemperature)°")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(config.accentColor.color)
                    }

                    Text(config.weatherCondition)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var weatherIconName: String {
        switch config.weatherCondition.lowercased() {
        case let c where c.contains("rain"): return "cloud.rain.fill"
        case let c where c.contains("cloud"): return "cloud.fill"
        case let c where c.contains("snow"): return "snowflake"
        case let c where c.contains("storm"): return "cloud.bolt.fill"
        default: return "sun.max.fill"
        }
    }
}

// MARK: - Battery Widget

struct BatteryWidgetView: View {
    let config: WidgetConfiguration

    var body: some View {
        GlassWidgetCard(config: config) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.15), lineWidth: 3)
                        .frame(width: 26, height: 26)

                    Circle()
                        .trim(from: 0, to: CGFloat(config.batteryPercentage) / 100.0)
                        .stroke(config.accentColor.color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 26, height: 26)

                    Image(systemName: config.batteryCharging ? "bolt.fill" : "laptopcomputer")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(config.accentColor.color)
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text("\(config.batteryPercentage)%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.primary)

                    Text(config.batteryCharging ? "Charging" : "MacBook Battery")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Calendar Widget

struct CalendarWidgetView: View {
    let config: WidgetConfiguration

    var body: some View {
        GlassWidgetCard(config: config) {
            HStack(spacing: 10) {
                VStack(spacing: 0) {
                    Text("SEP")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(config.accentColor.color)

                    Text("27")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.primary)
                }
                .frame(width: 24)

                VStack(alignment: .leading, spacing: 1) {
                    Text(config.calendarEventTitle)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(config.calendarEventTime)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - System Info Widget

struct SystemInfoWidgetView: View {
    let config: WidgetConfiguration
    private let sysInfo = SystemInfoService.shared

    var body: some View {
        GlassWidgetCard(config: config) {
            HStack(spacing: 10) {
                Image(systemName: "cpu")
                    .font(.system(size: 16))
                    .foregroundStyle(config.accentColor.color)

                VStack(alignment: .leading, spacing: 1) {
                    Text(sysInfo.hostName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text("\(sysInfo.macOSVersion) • \(sysInfo.memoryInfo)")
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Glass Widget Card Helper

struct GlassWidgetCard<Content: View>: View {
    let config: WidgetConfiguration
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                switch config.style {
                case .glass:
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(config.opacity))
                        .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                case .ultraThin:
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .fill(.thinMaterial.opacity(0.4))
                case .solid:
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .fill(Color.black.opacity(0.65))
                case .subtleOutline:
                    RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                        .fill(Color.black.opacity(0.25))
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 0.8)
            }
    }
}

// MARK: - SwiftUI Previews

#Preview("Widget Container Row") {
    ZStack {
        Color.indigo
        WidgetContainerView(config: WidgetConfiguration())
    }
    .frame(width: 600, height: 120)
}

#Preview("Weather & Battery Widgets") {
    ZStack {
        LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        HStack(spacing: 12) {
            WeatherWidgetView(config: WidgetConfiguration())
            BatteryWidgetView(config: WidgetConfiguration())
        }
    }
    .frame(width: 450, height: 100)
}
