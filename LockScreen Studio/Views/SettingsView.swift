//
//  SettingsView.swift
//  LockScreen Studio
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct SettingsView: View {
    @Bindable var store: ThemeEditorStore

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                // Hardware Framing Options
                InspectorSection(title: "Hardware Frame", iconName: "laptopcomputer") {
                    Picker("Frame Mode", selection: $store.hardwareFrame) {
                        ForEach(HardwareFrameMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.radioGroup)
                }

                // Display Aspect Ratio
                InspectorSection(title: "Display Aspect Ratio", iconName: "aspectratio") {
                    Picker("Ratio", selection: $store.aspectRatio) {
                        ForEach(PreviewAspectRatio.allCases) { ratio in
                            Text(ratio.rawValue).tag(ratio)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Export Options
                InspectorSection(title: "Export & Render", iconName: "square.and.arrow.up") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Export the current lock screen preview directly to a high-resolution image file for your Mac desktop.")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)

                        Button {
                            exportLockscreenImage()
                        } label: {
                            Label("Export Lock Screen Image...", systemImage: "arrow.down.doc.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                // App Info Card
                InspectorSection(title: "About LockScreen Studio", iconName: "info.circle") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Version")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("1.0 (Build 100)")
                                .font(.system(size: 11, weight: .semibold))
                        }

                        HStack {
                            Text("Engine")
                                .font(.system(size: 11))
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("Native SwiftUI & SwiftData")
                                .font(.system(size: 11, weight: .semibold))
                        }
                    }
                }
            }
            .padding(14)
        }
    }

    private func exportLockscreenImage() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "\(store.activeTheme.name.replacingOccurrences(of: " ", with: "_"))_LockScreen.png"

        if panel.runModal() == .OK, let url = panel.url {
            let preview = MacPreview(
                theme: store.activeTheme,
                hardwareMode: .frameless,
                aspectRatio: store.aspectRatio,
                customImage: store.loadedCustomImage
            )

            if let nsImage = ImageProcessingService.shared.renderViewToImage(view: preview, size: CGSize(width: 1920, height: 1200)),
               let tiffData = nsImage.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData),
               let pngData = bitmap.representation(using: .png, properties: [:]) {
                try? pngData.write(to: url)
                store.showToast("Exported to \(url.lastPathComponent)")
            }
        }
    }
}

#Preview("Settings Inspector View") {
    SettingsView(store: ThemeEditorStore())
        .frame(width: 320, height: 600)
}
