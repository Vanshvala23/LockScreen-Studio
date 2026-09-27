//
//  WallpaperView.swift
//  LockScreen Studio
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct WallpaperView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Wallpaper Type Selection
                InspectorSection(title: "Wallpaper Type", iconName: "photo.fill") {
                    Picker("Source", selection: $store.activeTheme.wallpaperConfig.type) {
                        ForEach(WallpaperType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Type-Specific Options
                switch store.activeTheme.wallpaperConfig.type {
                case .gradient:
                    renderGradientOptions()
                case .solidColor:
                    renderSolidColorOptions()
                case .customImage:
                    renderCustomImageOptions()
                }

                // Image Adjustments
                InspectorSection(title: "Adjustments", iconName: "slider.horizontal.3") {
                    VStack(spacing: 12) {
                        SliderRow(
                            label: "Blur",
                            value: $store.activeTheme.wallpaperConfig.blur,
                            range: 0...30,
                            format: "%.1f px"
                        )

                        SliderRow(
                            label: "Brightness",
                            value: $store.activeTheme.wallpaperConfig.brightness,
                            range: -0.5...0.5,
                            format: "%.2f"
                        )

                        SliderRow(
                            label: "Contrast",
                            value: $store.activeTheme.wallpaperConfig.contrast,
                            range: 0.5...1.5,
                            format: "%.2f"
                        )

                        SliderRow(
                            label: "Saturation",
                            value: $store.activeTheme.wallpaperConfig.saturation,
                            range: 0.0...2.0,
                            format: "%.2f"
                        )

                        SliderRow(
                            label: "Opacity",
                            value: $store.activeTheme.wallpaperConfig.opacity,
                            range: 0.0...1.0,
                            format: "%.0f%%",
                            scale: 100
                        )
                    }
                }

                // Scaling & Cropping Controls
                if store.activeTheme.wallpaperConfig.type == .customImage {
                    InspectorSection(title: "Scaling & Crop", iconName: "crop") {
                        VStack(spacing: 12) {
                            Picker("Mode", selection: $store.activeTheme.wallpaperConfig.scaleMode) {
                                ForEach(ScaleMode.allCases) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }

                            if store.activeTheme.wallpaperConfig.scaleMode == .custom {
                                SliderRow(
                                    label: "Zoom",
                                    value: $store.activeTheme.wallpaperConfig.zoomScale,
                                    range: 0.5...3.0,
                                    format: "%.2fx"
                                )

                                SliderRow(
                                    label: "Offset X",
                                    value: $store.activeTheme.wallpaperConfig.offsetX,
                                    range: -200...200,
                                    format: "%.0f px"
                                )

                                SliderRow(
                                    label: "Offset Y",
                                    value: $store.activeTheme.wallpaperConfig.offsetY,
                                    range: -200...200,
                                    format: "%.0f px"
                                )
                            }
                        }
                    }
                }
            }
            .padding(14)
        }
    }

    // MARK: - Gradient Presets Selector

    @ViewBuilder
    private func renderGradientOptions() -> some View {
        InspectorSection(title: "Gradient Style", iconName: "paintpalette") {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(GradientPreset.allCases) { preset in
                    Button {
                        withAnimation {
                            store.activeTheme.wallpaperConfig.gradientPreset = preset
                        }
                    } label: {
                        HStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(LinearGradient(
                                    colors: preset.colors.map { $0.color },
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 28, height: 28)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                                )

                            Text(preset.rawValue)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.primary)
                                .lineLimit(1)

                            Spacer()
                        }
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(store.activeTheme.wallpaperConfig.gradientPreset == preset ? Color.accentColor.opacity(0.15) : Color.primary.opacity(0.03))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(store.activeTheme.wallpaperConfig.gradientPreset == preset ? Color.accentColor : Color.clear, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - Solid Color Selector

    @ViewBuilder
    private func renderSolidColorOptions() -> some View {
        InspectorSection(title: "Color Picker", iconName: "eyedropper") {
            ColorPicker(
                "Background Color",
                selection: Binding(
                    get: { store.activeTheme.wallpaperConfig.solidColor.color },
                    set: { store.activeTheme.wallpaperConfig.solidColor = CodableColor(color: $0) }
                )
            )
            .font(.system(size: 12, weight: .medium))
        }
    }

    // MARK: - Custom Image Chooser

    @ViewBuilder
    private func renderCustomImageOptions() -> some View {
        InspectorSection(title: "Image Selection", iconName: "photo.badge.plus") {
            VStack(spacing: 10) {
                if let loadedImg = store.loadedCustomImage {
                    Image(nsImage: loadedImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }

                Button {
                    chooseLocalFile()
                } label: {
                    Label(store.loadedCustomImage == nil ? "Choose Image File..." : "Change Image...", systemImage: "folder")
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func chooseLocalFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url {
            if let image = NSImage(contentsOf: url) {
                store.loadedCustomImage = image
                store.activeTheme.wallpaperConfig.customImagePath = url.path
                store.showToast("Loaded image: \(url.lastPathComponent)")
            }
        }
    }
}

#Preview("Wallpaper Inspector View") {
    WallpaperView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
