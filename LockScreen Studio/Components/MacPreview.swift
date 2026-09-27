//
//  MacPreview.swift
//  LockScreen Studio
//

import SwiftUI
import AppKit

struct MacPreview: View {
    let theme: LockScreenTheme
    let hardwareMode: HardwareFrameMode
    let aspectRatio: PreviewAspectRatio
    var customImage: NSImage? = nil

    @State private var processedWallpaperImage: NSImage? = nil

    var body: some View {
        GeometryReader { geometry in
            let containerSize = fitSize(in: geometry.size)

            ZStack {
                switch hardwareMode {
                case .macbookPro:
                    renderMacBookProFrame(size: containerSize)
                case .studioDisplay:
                    renderStudioDisplayFrame(size: containerSize)
                case .frameless:
                    renderLockScreenCanvas(size: containerSize)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task(id: theme.wallpaperConfig) {
            updateProcessedWallpaper()
        }
        .onChange(of: customImage) { _, newImg in
            updateProcessedWallpaper(with: newImg)
        }
    }

    // MARK: - Screen Canvas Renderer

    @ViewBuilder
    private func renderLockScreenCanvas(size: CGSize) -> some View {
        ZStack {
            // Layer 1: Wallpaper
            wallpaperBackgroundView()

            // Layer 2: Color Tint Overlay
            if theme.effectsConfig.colorTintEnabled {
                theme.effectsConfig.colorTint.color
                    .opacity(theme.effectsConfig.tintIntensity)
                    .blendMode(.color)
            }

            // Layer 3: Vignette & CRT overlays
            if theme.effectsConfig.vignette > 0 {
                VignetteOverlay(intensity: theme.effectsConfig.vignette)
            }

            if theme.effectsConfig.crtScanlines {
                CRTScanlinesOverlay()
                    .opacity(0.15)
            }

            // Layer 4: Screen Dimming
            if theme.effectsConfig.dimmingLevel > 0 {
                Color.black.opacity(theme.effectsConfig.dimmingLevel)
            }

            // Layer 5: Top Menu Bar
            VStack {
                menuBarView()
                Spacer()
            }

            // Layer 6: Dynamic Lock Screen Clock & Widgets
            lockScreenContentOverlay(size: size)

            // Layer 7: Bottom Unlock User Prompt
            VStack {
                Spacer()
                unlockPromptView()
                    .padding(.bottom, 16)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipped()
    }

    // MARK: - Hardware Frames

    @ViewBuilder
    private func renderMacBookProFrame(size: CGSize) -> some View {
        VStack(spacing: 0) {
            // Display Screen Bezel
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(white: 0.08))
                    .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)

                renderLockScreenCanvas(size: size)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(10)

                // Notch
                MacBookNotchView()
            }
            .frame(width: size.width + 20, height: size.height + 20)

            // Laptop Aluminum Base Notch & Hinge
            ZStack {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(LinearGradient(
                        colors: [Color(white: 0.75), Color(white: 0.55), Color(white: 0.35)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .frame(width: size.width + 60, height: 12)

                // Bottom Notch Indent
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(white: 0.25))
                    .frame(width: 60, height: 4)
                    .offset(y: -3)
            }
        }
    }

    @ViewBuilder
    private func renderStudioDisplayFrame(size: CGSize) -> some View {
        VStack(spacing: 0) {
            // Monitor Bezel
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.black)
                    .shadow(color: .black.opacity(0.45), radius: 24, x: 0, y: 12)

                renderLockScreenCanvas(size: size)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .padding(14)
            }
            .frame(width: size.width + 28, height: size.height + 28)

            // Aluminum Stand Stem
            Rectangle()
                .fill(LinearGradient(
                    colors: [Color(white: 0.7), Color(white: 0.45)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: 80, height: 70)

            // Aluminum Stand Base Foot
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient(
                    colors: [Color(white: 0.8), Color(white: 0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .frame(width: 180, height: 8)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }

    // MARK: - Wallpaper View

    @ViewBuilder
    private func wallpaperBackgroundView() -> some View {
        let config = theme.wallpaperConfig

        Group {
            switch config.type {
            case .gradient:
                LinearGradient(
                    colors: config.gradientPreset.colors.map { $0.color },
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .solidColor:
                config.solidColor.color
            case .customImage:
                if let processed = processedWallpaperImage {
                    Image(nsImage: processed)
                        .resizable()
                        .aspectRatio(contentMode: config.scaleMode == .fill ? .fill : .fit)
                        .scaleEffect(config.zoomScale)
                        .offset(x: config.offsetX, y: config.offsetY)
                } else {
                    LinearGradient(
                        colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        }
        .opacity(config.opacity)
    }

    // MARK: - Menu Bar View

    @ViewBuilder
    private func menuBarView() -> some View {
        HStack {
            Image(systemName: "apple.logo")
                .font(.system(size: 11, weight: .bold))

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
                Image(systemName: "controlcenter")
            }
            .font(.system(size: 11, weight: .medium))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .foregroundStyle(.white.opacity(0.9))
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.35), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Lock Screen Overlay Layout

    @ViewBuilder
    private func lockScreenContentOverlay(size: CGSize) -> some View {
        let position = theme.clockConfig.position

        ZStack {
            VStack(spacing: 14) {
                if position == .topCenter {
                    ClockPreview(config: theme.clockConfig)
                        .offset(x: theme.clockConfig.customOffsetX, y: theme.clockConfig.customOffsetY)

                    if theme.widgetConfig.position == .topBelowClock {
                        WidgetContainerView(config: theme.widgetConfig)
                    }
                } else if position == .center {
                    Spacer()
                    ClockPreview(config: theme.clockConfig)
                        .offset(x: theme.clockConfig.customOffsetX, y: theme.clockConfig.customOffsetY)

                    if theme.widgetConfig.position == .topBelowClock {
                        WidgetContainerView(config: theme.widgetConfig)
                    }
                    Spacer()
                } else if position == .topLeft {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            ClockPreview(config: theme.clockConfig)
                            if theme.widgetConfig.position == .topBelowClock {
                                WidgetContainerView(config: theme.widgetConfig)
                            }
                        }
                        .offset(x: theme.clockConfig.customOffsetX, y: theme.clockConfig.customOffsetY)
                        Spacer()
                    }
                    .padding(.leading, 24)
                } else if position == .topRight {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 10) {
                            ClockPreview(config: theme.clockConfig)
                            if theme.widgetConfig.position == .topBelowClock {
                                WidgetContainerView(config: theme.widgetConfig)
                            }
                        }
                        .offset(x: theme.clockConfig.customOffsetX, y: theme.clockConfig.customOffsetY)
                    }
                    .padding(.trailing, 24)
                } else {
                    ClockPreview(config: theme.clockConfig)
                        .offset(x: theme.clockConfig.customOffsetX, y: theme.clockConfig.customOffsetY)
                }
            }
            .padding(.top, 40)

            // Sidebars / Bottom Widgets
            if theme.widgetConfig.position == .leftSidebar {
                HStack {
                    WidgetContainerView(config: theme.widgetConfig)
                        .padding(.leading, 16)
                    Spacer()
                }
            } else if theme.widgetConfig.position == .rightSidebar {
                HStack {
                    Spacer()
                    WidgetContainerView(config: theme.widgetConfig)
                        .padding(.trailing, 16)
                }
            } else if theme.widgetConfig.position == .bottomRow {
                VStack {
                    Spacer()
                    WidgetContainerView(config: theme.widgetConfig)
                        .padding(.bottom, 48)
                }
            }
        }
    }

    // MARK: - Unlock User Avatar Prompt

    @ViewBuilder
    private func unlockPromptView() -> some View {
        VStack(spacing: 6) {
            Image(systemName: "touchid")
                .font(.system(size: 26, weight: .light))
                .foregroundStyle(.white.opacity(0.85))

            HStack(spacing: 6) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)

                Text("Touch ID or Press Any Key to Unlock")
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundStyle(.white.opacity(0.75))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Capsule().fill(.ultraThinMaterial.opacity(0.4)))
        }
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
    }

    // MARK: - Helpers

    private func fitSize(in availableSize: CGSize) -> CGSize {
        let targetRatio = aspectRatio.ratio
        let availableRatio = availableSize.width / availableSize.height

        var width: CGFloat
        var height: CGFloat

        if availableRatio > targetRatio {
            height = min(availableSize.height - 40, 520)
            width = height * targetRatio
        } else {
            width = min(availableSize.width - 40, 800)
            height = width / targetRatio
        }

        return CGSize(width: max(280, width), height: max(180, height))
    }

    private func updateProcessedWallpaper(with img: NSImage? = nil) {
        let sourceImg = img ?? customImage
        guard let sourceImg else { return }

        Task {
            let processed = ImageProcessingService.shared.processImage(
                sourceImg,
                brightness: theme.wallpaperConfig.brightness,
                blur: theme.wallpaperConfig.blur,
                saturation: theme.wallpaperConfig.saturation,
                contrast: theme.wallpaperConfig.contrast
            )
            await MainActor.run {
                self.processedWallpaperImage = processed
            }
        }
    }
}

// MARK: - MacBook Camera Notch View

struct MacBookNotchView: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.blue.opacity(0.7))
                .frame(width: 4, height: 4)
            Circle()
                .fill(Color(white: 0.15))
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color.black)
        )
    }
}

// MARK: - Vignette Overlay View

struct VignetteOverlay: View {
    let intensity: Double

    var body: some View {
        RadialGradient(
            colors: [Color.clear, Color.black.opacity(intensity)],
            center: .center,
            startRadius: 80,
            endRadius: 450
        )
    }
}

// MARK: - CRT Scanlines Overlay

struct CRTScanlinesOverlay: View {
    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<150, id: \.self) { _ in
                Divider()
                    .background(Color.black.opacity(0.18))
            }
        }
    }
}

#Preview("MacBook Pro Frame") {
    MacPreview(
        theme: PresetThemes.presets[0],
        hardwareMode: .macbookPro,
        aspectRatio: .sixteenTen
    )
    .frame(width: 800, height: 500)
    .padding()
}

#Preview("Studio Display Frame") {
    MacPreview(
        theme: PresetThemes.presets[3],
        hardwareMode: .studioDisplay,
        aspectRatio: .sixteenNine
    )
    .frame(width: 800, height: 500)
    .padding()
}
