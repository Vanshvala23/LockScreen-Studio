//
//  ClockPreview.swift
//  LockScreen Studio
//

import SwiftUI

struct ClockPreview: View {
    let config: ClockConfiguration

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { context in
            let currentDate = config.isLiveTime ? context.date : sampleDate

            VStack(spacing: 8) {
                switch config.style {
                case .digitalStandard, .digitalMinimal, .digitalBold, .digitalCompact:
                    renderDigitalClock(for: currentDate)
                case .typographyHero:
                    renderTypographyHeroClock(for: currentDate)
                case .liquidGlassHUD:
                    renderLiquidGlassHUDClock(for: currentDate)
                case .retroFlip:
                    renderRetroFlipClock(for: currentDate)
                case .analogClassic:
                    renderAnalogClock(for: currentDate)
                }

                if config.showDate {
                    renderDateString(for: currentDate)
                }
            }
            .foregroundStyle(config.textColor.color)
            .opacity(config.opacity)
        }
    }

    // MARK: - Digital Clock View

    @ViewBuilder
    private func renderDigitalClock(for date: Date) -> some View {
        let timeString = formattedTimeString(for: date)

        Text(timeString)
            .font(.system(
                size: adjustedFontSize,
                weight: config.fontWeight.fontWeight,
                design: config.fontDesign.fontDesign
            ))
            .shadow(color: .black.opacity(0.35), radius: 6, x: 0, y: 3)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }

    // MARK: - Typography Hero Clock View

    @ViewBuilder
    private func renderTypographyHeroClock(for date: Date) -> some View {
        let hourString = formattedHourString(for: date)
        let minuteString = formattedMinuteString(for: date)

        VStack(spacing: -12) {
            Text(hourString)
                .font(.system(
                    size: adjustedFontSize * 1.1,
                    weight: .heavy,
                    design: config.fontDesign.fontDesign
                ))
            Text(minuteString)
                .font(.system(
                    size: adjustedFontSize * 1.1,
                    weight: .thin,
                    design: config.fontDesign.fontDesign
                ))
        }
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }

    // MARK: - Unique Style 1: Liquid Glass HUD Clock

    @ViewBuilder
    private func renderLiquidGlassHUDClock(for date: Date) -> some View {
        let hourStr = formattedHourString(for: date)
        let minStr = formattedMinuteString(for: date)
        let secStr = formattedSecondString(for: date)

        HStack(spacing: 8) {
            // Hour Pill
            Text(hourStr)
                .font(.system(size: adjustedFontSize * 0.9, weight: .bold, design: config.fontDesign.fontDesign))
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial.opacity(0.6))
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(
                        LinearGradient(
                            colors: [config.textColor.color.opacity(0.8), Color.cyan.opacity(0.4), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                )

            Text(":")
                .font(.system(size: adjustedFontSize * 0.75, weight: .bold))
                .opacity(0.8)

            // Minute Pill
            Text(minStr)
                .font(.system(size: adjustedFontSize * 0.9, weight: .bold, design: config.fontDesign.fontDesign))
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial.opacity(0.6))
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(
                        LinearGradient(
                            colors: [Color.cyan.opacity(0.6), config.textColor.color.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
                )

            if config.showSeconds {
                Text(secStr)
                    .font(.system(size: adjustedFontSize * 0.4, weight: .semibold, design: .monospaced))
                    .foregroundStyle(Color.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.black.opacity(0.3)))
            }
        }
        .shadow(color: Color.cyan.opacity(0.3), radius: 10, x: 0, y: 2)
    }

    // MARK: - Unique Style 2: Retro Flip Card Clock

    @ViewBuilder
    private func renderRetroFlipClock(for date: Date) -> some View {
        let hourStr = formattedHourString(for: date)
        let minStr = formattedMinuteString(for: date)

        HStack(spacing: 10) {
            FlipCardUnit(text: hourStr, fontSize: adjustedFontSize * 0.85, fontDesign: config.fontDesign.fontDesign, textColor: config.textColor.color)
            
            VStack(spacing: 6) {
                Circle().fill(config.textColor.color.opacity(0.8)).frame(width: 6, height: 6)
                Circle().fill(config.textColor.color.opacity(0.8)).frame(width: 6, height: 6)
            }
            
            FlipCardUnit(text: minStr, fontSize: adjustedFontSize * 0.85, fontDesign: config.fontDesign.fontDesign, textColor: config.textColor.color)
        }
    }

    // MARK: - Analog Clock View

    @ViewBuilder
    private func renderAnalogClock(for date: Date) -> some View {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)

        let hourAngle = Double(hour % 12 + minute / 60) * 30.0
        let minuteAngle = Double(minute) * 6.0
        let secondAngle = Double(second) * 6.0

        ZStack {
            Circle()
                .fill(.ultraThinMaterial.opacity(0.4))
                .overlay(Circle().stroke(config.textColor.color.opacity(0.5), lineWidth: 2))
                .frame(width: adjustedFontSize * 1.8, height: adjustedFontSize * 1.8)

            // Hour marks
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(config.textColor.color.opacity(0.7))
                    .frame(width: 2, height: 8)
                    .offset(y: -(adjustedFontSize * 0.75))
                    .rotationEffect(.degrees(Double(i) * 30))
            }

            // Hour hand
            RoundedRectangle(cornerRadius: 3)
                .fill(config.textColor.color)
                .frame(width: 4, height: adjustedFontSize * 0.45)
                .offset(y: -(adjustedFontSize * 0.22))
                .rotationEffect(.degrees(hourAngle))

            // Minute hand
            RoundedRectangle(cornerRadius: 2)
                .fill(config.textColor.color)
                .frame(width: 3, height: adjustedFontSize * 0.65)
                .offset(y: -(adjustedFontSize * 0.32))
                .rotationEffect(.degrees(minuteAngle))

            // Second hand
            if config.showSeconds {
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: 1.5, height: adjustedFontSize * 0.7)
                    .offset(y: -(adjustedFontSize * 0.35))
                    .rotationEffect(.degrees(secondAngle))
            }

            // Center pin
            Circle()
                .fill(config.textColor.color)
                .frame(width: 8, height: 8)
        }
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }

    // MARK: - Date String View

    @ViewBuilder
    private func renderDateString(for date: Date) -> some View {
        Text(formattedDateString(for: date))
            .font(.system(
                size: max(12, adjustedFontSize * 0.24),
                weight: .medium,
                design: config.fontDesign.fontDesign
            ))
            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
    }

    // MARK: - Helpers

    private var sampleDate: Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 9
        components.day = 27
        components.hour = 9
        components.minute = 41
        components.second = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    private var adjustedFontSize: CGFloat {
        CGFloat(config.fontSize) * 0.7
    }

    private func formattedTimeString(for date: Date) -> String {
        let formatter = DateFormatter()
        if config.is24Hour {
            formatter.dateFormat = config.showSeconds ? "HH:mm:ss" : "HH:mm"
        } else {
            formatter.dateFormat = config.showSeconds ? "h:mm:ss a" : "h:mm"
        }
        return formatter.string(from: date)
    }

    private func formattedHourString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = config.is24Hour ? "HH" : "hh"
        return formatter.string(from: date)
    }

    private func formattedMinuteString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: date)
    }

    private func formattedSecondString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ss"
        return formatter.string(from: date)
    }

    private func formattedDateString(for date: Date) -> String {
        let formatter = DateFormatter()
        switch config.dateStyle {
        case .full:
            formatter.dateFormat = "EEEE, MMMM d"
        case .medium:
            formatter.dateFormat = "EEE, MMM d"
        case .short:
            formatter.dateFormat = "MM/dd/yyyy"
        case .uppercase:
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date).uppercased()
        }
        return formatter.string(from: date)
    }
}

// MARK: - Flip Card Component Helper

struct FlipCardUnit: View {
    let text: String
    let fontSize: CGFloat
    let fontDesign: Font.Design
    let textColor: Color

    var body: some View {
        ZStack {
            // Dark flip card background
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(LinearGradient(
                    colors: [Color(white: 0.18), Color(white: 0.08)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )

            // Number text
            Text(text)
                .font(.system(size: fontSize, weight: .bold, design: fontDesign))
                .foregroundStyle(textColor)
                .padding(.horizontal, 14)
                .padding(.vertical, 4)

            // Horizontal Split Divider Line
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .frame(height: 1.5)
        }
        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 3)
    }
}

// MARK: - SwiftUI Preview Provider

#Preview("Digital Bold Clock") {
    ZStack {
        Color.indigo
        ClockPreview(config: ClockConfiguration(style: .digitalBold))
    }
    .frame(width: 400, height: 200)
}

#Preview("Liquid Glass HUD Clock") {
    ZStack {
        LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom)
        ClockPreview(config: ClockConfiguration(style: .liquidGlassHUD))
    }
    .frame(width: 400, height: 200)
}

#Preview("Retro Flip Card Clock") {
    ZStack {
        Color.black
        ClockPreview(config: ClockConfiguration(style: .retroFlip))
    }
    .frame(width: 400, height: 200)
}
