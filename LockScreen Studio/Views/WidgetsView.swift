//
//  WidgetsView.swift
//  LockScreen Studio
//

import SwiftUI

struct WidgetsView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Active Widgets Selector
                InspectorSection(title: "Active Widgets", iconName: "square.stack.3d.up") {
                    VStack(alignment: .leading, spacing: 10) {
                        Toggle("Weather Widget", isOn: $store.activeTheme.widgetConfig.showWeather)
                        Toggle("Battery Widget", isOn: $store.activeTheme.widgetConfig.showBattery)
                        Toggle("Calendar Events Widget", isOn: $store.activeTheme.widgetConfig.showCalendar)
                        Toggle("System Info (CPU & RAM)", isOn: $store.activeTheme.widgetConfig.showSystemInfo)
                    }
                    .font(.system(size: 12, weight: .medium))
                }

                // Layout & Position
                InspectorSection(title: "Widget Placement", iconName: "rectangle.3.group") {
                    VStack(spacing: 12) {
                        Picker("Position", selection: $store.activeTheme.widgetConfig.position) {
                            ForEach(WidgetPosition.allCases) { pos in
                                Text(pos.rawValue).tag(pos)
                            }
                        }

                        Picker("Glass Container Style", selection: $store.activeTheme.widgetConfig.style) {
                            ForEach(WidgetStyle.allCases) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }

                        ColorPicker(
                            "Widget Accent Color",
                            selection: Binding(
                                get: { store.activeTheme.widgetConfig.accentColor.color },
                                set: { store.activeTheme.widgetConfig.accentColor = CodableColor(color: $0) }
                            )
                        )

                        SliderRow(
                            label: "Background Opacity",
                            value: $store.activeTheme.widgetConfig.opacity,
                            range: 0.1...1.0,
                            format: "%.0f%%",
                            scale: 100
                        )

                        SliderRow(
                            label: "Corner Radius",
                            value: $store.activeTheme.widgetConfig.cornerRadius,
                            range: 4...24,
                            format: "%.0f px"
                        )
                    }
                }

                // Mock Data Editor
                InspectorSection(title: "Mock Data Settings", iconName: "slider.horizontal.2.square.on.square") {
                    VStack(alignment: .leading, spacing: 12) {
                        if store.activeTheme.widgetConfig.showWeather {
                            Text("Weather Settings")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)

                            HStack(spacing: 8) {
                                TextField("City", text: $store.activeTheme.widgetConfig.weatherCity)
                                    .textFieldStyle(.roundedBorder)

                                TextField("Temp", value: $store.activeTheme.widgetConfig.weatherTemperature, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 50)
                            }

                            TextField("Condition", text: $store.activeTheme.widgetConfig.weatherCondition)
                                .textFieldStyle(.roundedBorder)
                        }

                        if store.activeTheme.widgetConfig.showBattery {
                            Divider()

                            Text("Battery Status")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)

                            SliderRow(
                                label: "Percentage",
                                value: Binding(
                                    get: { Double(store.activeTheme.widgetConfig.batteryPercentage) },
                                    set: { store.activeTheme.widgetConfig.batteryPercentage = Int($0) }
                                ),
                                range: 1...100,
                                format: "%.0f%%"
                            )

                            Toggle("Charging Indicator", isOn: $store.activeTheme.widgetConfig.batteryCharging)
                                .font(.system(size: 11))
                        }

                        if store.activeTheme.widgetConfig.showCalendar {
                            Divider()

                            Text("Calendar Event")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.secondary)

                            TextField("Event Title", text: $store.activeTheme.widgetConfig.calendarEventTitle)
                                .textFieldStyle(.roundedBorder)

                            TextField("Event Time", text: $store.activeTheme.widgetConfig.calendarEventTime)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
            }
            .padding(14)
        }
    }
}

#Preview("Widgets Inspector View") {
    WidgetsView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
