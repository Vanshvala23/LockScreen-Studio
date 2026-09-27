//
//  EffectsView.swift
//  LockScreen Studio
//

import SwiftUI

struct EffectsView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Vignette & Dimming
                InspectorSection(title: "Lighting & Vignette", iconName: "sun.max") {
                    VStack(spacing: 12) {
                        SliderRow(
                            label: "Vignette Darkness",
                            value: $store.activeTheme.effectsConfig.vignette,
                            range: 0.0...0.8,
                            format: "%.0f%%",
                            scale: 100
                        )

                        SliderRow(
                            label: "Screen Dimming Level",
                            value: $store.activeTheme.effectsConfig.dimmingLevel,
                            range: 0.0...0.6,
                            format: "%.0f%%",
                            scale: 100
                        )
                    }
                }

                // Color Tinting Overlay
                InspectorSection(title: "Color Overlay & Tint", iconName: "drop") {
                    VStack(spacing: 12) {
                        Toggle("Enable Color Tinting", isOn: $store.activeTheme.effectsConfig.colorTintEnabled)
                            .font(.system(size: 12, weight: .medium))

                        if store.activeTheme.effectsConfig.colorTintEnabled {
                            ColorPicker(
                                "Tint Color",
                                selection: Binding(
                                    get: { store.activeTheme.effectsConfig.colorTint.color },
                                    set: { store.activeTheme.effectsConfig.colorTint = CodableColor(color: $0) }
                                )
                            )

                            SliderRow(
                                label: "Tint Opacity",
                                value: $store.activeTheme.effectsConfig.tintIntensity,
                                range: 0.05...0.6,
                                format: "%.0f%%",
                                scale: 100
                            )
                        }
                    }
                }

                // Retro & Textural FX
                InspectorSection(title: "Texture & CRT Effects", iconName: "wand.and.rays") {
                    VStack(spacing: 12) {
                        SliderRow(
                            label: "Film Grain Intensity",
                            value: $store.activeTheme.effectsConfig.filmGrain,
                            range: 0.0...0.5,
                            format: "%.0f%%",
                            scale: 100
                        )

                        Toggle("Retro CRT Scanlines", isOn: $store.activeTheme.effectsConfig.crtScanlines)
                            .font(.system(size: 12, weight: .medium))
                    }
                }
            }
            .padding(14)
        }
    }
}

#Preview("Effects Inspector View") {
    EffectsView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
