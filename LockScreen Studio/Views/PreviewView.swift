//
//  PreviewView.swift
//  LockScreen Studio
//

import SwiftUI

struct PreviewView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        VStack(spacing: 0) {
            // Top Preview Action Bar
            HStack(spacing: 14) {
                // Hardware Frame Picker
                Menu {
                    Picker("Hardware Frame", selection: $store.hardwareFrame) {
                        ForEach(HardwareFrameMode.allCases) { mode in
                            Label(mode.rawValue, systemImage: frameIcon(for: mode)).tag(mode)
                        }
                    }
                } label: {
                    Label(store.hardwareFrame.rawValue, systemImage: frameIcon(for: store.hardwareFrame))
                        .font(.system(size: 11, weight: .medium))
                }
                .menuStyle(.borderlessButton)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.primary.opacity(0.06)))

                // Aspect Ratio Picker
                Picker("Ratio", selection: $store.aspectRatio) {
                    ForEach(PreviewAspectRatio.allCases) { ratio in
                        Text(ratio.rawValue).tag(ratio)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 220)

                Spacer()

                // Set as Mac Wallpaper Button
                Button {
                    applyAsMacWallpaper()
                } label: {
                    Label("Set as Mac Wallpaper", systemImage: "desktopcomputer")
                        .font(.system(size: 11, weight: .semibold))
                }
                .buttonStyle(.borderedProminent)

                // Fullscreen Live Preview Button
                Button {
                    store.isFullPreviewPresented = true
                } label: {
                    Label("Fullscreen", systemImage: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 11, weight: .semibold))
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Material.bar)
            .overlay(AlignmentKeyView(), alignment: .bottom)

            // Main Interactive Mac Screen Canvas
            ZStack {
                Color(nsColor: .windowBackgroundColor).opacity(0.5)

                MacPreview(
                    theme: store.activeTheme,
                    hardwareMode: store.hardwareFrame,
                    aspectRatio: store.aspectRatio,
                    customImage: store.loadedCustomImage
                )
                .padding(24)

                // Toast Notification Overlay
                if let message = store.toastMessage {
                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text(message)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.black.opacity(0.85)))
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 24)
                    }
                    .animation(.easeInOut, value: store.toastMessage)
                }
            }
        }
        .sheet(isPresented: $store.isFullPreviewPresented) {
            ZStack(alignment: .topTrailing) {
                MacPreview(
                    theme: store.activeTheme,
                    hardwareMode: .frameless,
                    aspectRatio: store.aspectRatio,
                    customImage: store.loadedCustomImage
                )
                .ignoresSafeArea()
                .frame(minWidth: 900, minHeight: 600)

                Button {
                    store.isFullPreviewPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(24)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func frameIcon(for mode: HardwareFrameMode) -> String {
        switch mode {
        case .macbookPro: return "laptopcomputer"
        case .studioDisplay: return "display"
        case .frameless: return "rectangle"
        }
    }

    private func applyAsMacWallpaper() {
        let preview = MacPreview(
            theme: store.activeTheme,
            hardwareMode: .frameless,
            aspectRatio: store.aspectRatio,
            customImage: store.loadedCustomImage
        )

        if let nsImage = ImageProcessingService.shared.renderViewToImage(view: preview, size: CGSize(width: 2560, height: 1600)) {
            let success = ImageProcessingService.shared.setAsSystemWallpaper(nsImage: nsImage)
            if success {
                store.showToast("Applied design as Mac Wallpaper!")
            } else {
                store.showToast("Could not set wallpaper")
            }
        }
    }
}

struct AlignmentKeyView: View {
    var body: some View {
        Divider()
    }
}

#Preview("Main Preview Canvas") {
    PreviewView(store: ThemeEditorStore())
        .frame(width: 800, height: 600)
}
