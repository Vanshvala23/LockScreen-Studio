//
//  ClockView.swift
//  LockScreen Studio
//

import SwiftUI

struct ClockView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Clock Style Picker
                InspectorSection(title: "Clock Style", iconName: "clock") {
                    Picker("Style", selection: $store.activeTheme.clockConfig.style) {
                        ForEach(ClockStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.menu)
                }

                // Typography Controls
                InspectorSection(title: "Typography", iconName: "textformat") {
                    VStack(spacing: 12) {
                        Picker("Font Design", selection: $store.activeTheme.clockConfig.fontDesign) {
                            ForEach(ClockFontDesign.allCases) { design in
                                Text(design.rawValue).tag(design)
                            }
                        }

                        Picker("Font Weight", selection: $store.activeTheme.clockConfig.fontWeight) {
                            ForEach(ClockFontWeight.allCases) { weight in
                                Text(weight.rawValue).tag(weight)
                            }
                        }

                        SliderRow(
                            label: "Font Size",
                            value: $store.activeTheme.clockConfig.fontSize,
                            range: 32...140,
                            format: "%.0f pt"
                        )
                    }
                }

                // Color & Transparency
                InspectorSection(title: "Appearance", iconName: "paintpalette") {
                    VStack(spacing: 12) {
                        ColorPicker(
                            "Clock Color",
                            selection: Binding(
                                get: { store.activeTheme.clockConfig.textColor.color },
                                set: { store.activeTheme.clockConfig.textColor = CodableColor(color: $0) }
                            )
                        )

                        SliderRow(
                            label: "Opacity",
                            value: $store.activeTheme.clockConfig.opacity,
                            range: 0.1...1.0,
                            format: "%.0f%%",
                            scale: 100
                        )
                    }
                }

                // Clock Positioning
                InspectorSection(title: "Positioning", iconName: "arrow.up.and.down.and.arrow.left.and.right") {
                    VStack(spacing: 12) {
                        Picker("Screen Position", selection: $store.activeTheme.clockConfig.position) {
                            ForEach(ClockPosition.allCases) { pos in
                                Text(pos.rawValue).tag(pos)
                            }
                        }

                        if store.activeTheme.clockConfig.position == .custom {
                            SliderRow(
                                label: "Horizontal Offset",
                                value: $store.activeTheme.clockConfig.customOffsetX,
                                range: -150...150,
                                format: "%.0f px"
                            )

                            SliderRow(
                                label: "Vertical Offset",
                                value: $store.activeTheme.clockConfig.customOffsetY,
                                range: -150...150,
                                format: "%.0f px"
                            )
                        }
                    }
                }

                // Format Settings
                InspectorSection(title: "Time & Date Format", iconName: "calendar") {
                    VStack(spacing: 10) {
                        Toggle("24-Hour Time Format", isOn: $store.activeTheme.clockConfig.is24Hour)
                        Toggle("Show Seconds", isOn: $store.activeTheme.clockConfig.showSeconds)
                        Toggle("Live Clock Ticking", isOn: $store.activeTheme.clockConfig.isLiveTime)

                        Divider()

                        Toggle("Show Date Header", isOn: $store.activeTheme.clockConfig.showDate)

                        if store.activeTheme.clockConfig.showDate {
                            Picker("Date Style", selection: $store.activeTheme.clockConfig.dateStyle) {
                                ForEach(ClockDateStyle.allCases) { style in
                                    Text(style.rawValue).tag(style)
                                }
                            }
                        }
                    }
                    .font(.system(size: 12, weight: .medium))
                }
            }
            .padding(14)
        }
    }
}

#Preview("Clock Inspector View") {
    ClockView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
