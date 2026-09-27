//
//  ImageProcessingService.swift
//  LockScreen Studio
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import AppKit

final class ImageProcessingService {
    static let shared = ImageProcessingService()
    private let context = CIContext()

    private init() {}

    /// Applies brightness, contrast, saturation, and gaussian blur to an NSImage using CoreImage
    func processImage(
        _ inputImage: NSImage,
        brightness: Double,
        blur: Double,
        saturation: Double,
        contrast: Double
    ) -> NSImage {
        guard let cgImage = inputImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return inputImage
        }

        var ciImage = CIImage(cgImage: cgImage)

        // Color controls (brightness, contrast, saturation)
        if brightness != 0.0 || saturation != 1.0 || contrast != 1.0 {
            let filter = CIFilter.colorControls()
            filter.inputImage = ciImage
            filter.brightness = Float(brightness)
            filter.contrast = Float(contrast)
            filter.saturation = Float(saturation)
            if let output = filter.outputImage {
                ciImage = output
            }
        }

        // Gaussian blur
        if blur > 0.1 {
            let blurFilter = CIFilter.gaussianBlur()
            blurFilter.inputImage = ciImage
            blurFilter.radius = Float(blur)
            if let output = blurFilter.outputImage {
                // Crop back to original bounds to prevent blur edge expansion
                ciImage = output.clampedToExtent().cropped(to: CIImage(cgImage: cgImage).extent)
            }
        }

        guard let outputCGImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return inputImage
        }

        return NSImage(cgImage: outputCGImage, size: inputImage.size)
    }

    /// Renders a View to an NSImage for wallpaper export
    @MainActor
    func renderViewToImage<Content: View>(view: Content, size: CGSize) -> NSImage? {
        let renderer = ImageRenderer(content: view.frame(width: size.width, height: size.height))
        renderer.scale = 2.0
        return renderer.nsImage
    }

    /// Saves the rendered image temporarily and sets it as the active macOS Desktop / Lock Screen Wallpaper
    @MainActor
    func setAsSystemWallpaper(nsImage: NSImage) -> Bool {
        guard let tiffData = nsImage.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData),
              let pngData = bitmap.representation(using: .png, properties: [:]) else {
            return false
        }

        let tempDirectory = FileManager.default.temporaryDirectory
        let wallpaperURL = tempDirectory.appendingPathComponent("LockScreenStudio_Wallpaper.png")

        do {
            try pngData.write(to: wallpaperURL)
            for screen in NSScreen.screens {
                try NSWorkspace.shared.setDesktopImageURL(wallpaperURL, for: screen, options: [:])
            }
            return true
        } catch {
            print("Failed to set wallpaper: \(error.localizedDescription)")
            return false
        }
    }
}
