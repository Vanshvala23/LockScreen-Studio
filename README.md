# 📱 LockScreen Studio

> **Professional Lock Screen & Desktop Customization Workbench for macOS**

[![macOS](https://img.shields.io/badge/macOS-14.0%2B-blue.svg?style=flat&logo=apple)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.10%2B-orange.svg?style=flat&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Native-brightgreen.svg?style=flat&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![SwiftData](https://img.shields.io/badge/SwiftData-Persistence-purple.svg?style=flat&logo=swift)](https://developer.apple.com/documentation/swiftdata)

---

## 🌟 Overview

**LockScreen Studio** is a native macOS application built with **SwiftUI**, **SwiftData**, and **AppKit**. It provides a 3-pane workstation to design, customize, preview, and apply personalized lock screen themes and desktop wallpapers for your Mac.

Whether you prefer a minimal glass aesthetic, glowing cyber typography, or retro mechanical flip cards, LockScreen Studio allows you to tune wallpapers, clocks, glass widgets, and screen lighting overlays—then apply them directly to your macOS desktop with a single click.

---

## ✨ Features

### ⏰ Custom Clock Typography & Styles
- **`Liquid Glass HUD`**: Translucent floating liquid glass capsule badge (`.ultraThinMaterial`) with ambient glow, dynamic gradient borders, and glowing digital typography inspired by Apple design language.
- **`Retro Flip Card`**: Vintage mechanical split flip-card clock with dark cards, center split line dividers, and drop shadows.
- **`Digital Bold` & `Digital Minimal`**: Clean modern digital layouts.
- **`Typography Hero`**: Large editorial serif clock display.
- **Typography Controls**: Adjust font design (Rounded, Monospaced, Serif, System), font weight, size (32pt–140pt), opacity, 12/24-hour format, ticking seconds, live dates, and custom X/Y screen offsets.

### 🎨 Core Image Wallpaper Processing
- **Wallpaper Modes**: Dynamic Gradients (Aurora, Sonoma, Cyberpunk, Midnight, Sunset), Solid Colors, or Custom Local Image Files.
- **Live Image Filters**: Hardware-accelerated Gaussian Blur, Brightness, Contrast, Saturation, and Opacity via Core Image (`CIContext`).
- **Scaling & Crop**: Fit, Fill, Zoom (0.5x–3.0x), and Offset X/Y positioning.

### 🧩 Native Frosted Glass Widgets
- **Weather Widget**: Real-time mock weather conditions, temperature, and adaptive weather symbols.
- **Battery Widget**: Circular progress ring showing battery %, host device status, and charging indicator.
- **Calendar Widget**: Date badge with customizable event titles and time slots.
- **System Info Widget**: Displays macOS version, hostname, and memory specs (`SystemInfoService`).
- **Styles & Placement**: Ultra-thin glass, solid dark, or outline containers placed top-below-clock, bottom row, left sidebar, or right sidebar.

### 🪄 Visual Effects & Lighting Overlays
- **Vignette Lighting**: Subtle to deep radial edge darkening.
- **Color Overlay & Tint**: Blend custom color tints over wallpapers with controllable opacity.
- **Film Grain & Texture**: Synthetic film grain for vintage cinematic textures.
- **Retro CRT Scanlines**: Horizontal monitor scanlines overlay.

### 💻 Hardware Frame Enclosure Simulation
- **MacBook Pro Frame**: Simulates Apple Silicon MacBook Pro display with camera notch and aluminum notch base.
- **Studio Display Frame**: Simulates Apple Studio Display monitor with aluminum stand.
- **Frameless Desktop**: Clean full-bleed desktop canvas.
- **Aspect Ratios**: Native `16:10` (MacBook), `16:9` (Displays), and `4:3` (Classic).

### 🖥️ Direct macOS Integration & Exporting
- 🚀 **1-Click "Set as Mac Wallpaper"**: Automatically renders your lock screen design to high-resolution PNG and sets it across your active Mac displays using `NSWorkspace`.
- 📸 **High-Res PNG Export**: Render 1920x1200 / 2560x1600 wallpapers via `ImageRenderer`.
- 💾 **SwiftData Library**: Save, load, duplicate, rename, and delete custom lock screen themes persistent across app launches.

---

## 🏗️ Architecture & Tech Stack

LockScreen Studio follows clean architectural separation:

- **State Management**: Swift Concurrency (`@Observable`, `ThemeEditorStore`, `MainActor`, `TimelineView`).
- **UI Framework**: Native macOS SwiftUI three-pane layout (`NavigationSplitView`).
- **Persistence**: `SwiftData` (`@Model` classes, `@Query` auto-updating lists, graceful in-memory container fallback).
- **Graphics Engine**: `AppKit` + `CoreImage` + `ImageRenderer`.

```
LockScreen Studio/
├── Models/
│   ├── LockScreenTheme.swift        # SwiftData @Model root entity
│   ├── ClockConfiguration.swift     # Clock styles, fonts, format & placement
│   ├── WallpaperConfiguration.swift # Gradients, custom images, Core Image filters
│   ├── WidgetConfiguration.swift    # Active widgets, position & glass styling
│   ├── EffectsConfiguration.swift   # Vignette, tint, grain & CRT scanlines
│   └── CodableColor.swift           # RGBA Color persistence helper
├── Services/
│   ├── ThemeEditorStore.swift       # Central @Observable editor state manager
│   ├── ImageProcessingService.swift  # Core Image filter pipeline & NSWorkspace wallpaper setter
│   ├── PresetThemes.swift           # Built-in curated theme catalog
│   └── SystemInfoService.swift      # Host macOS hardware & memory reader
├── Components/
│   ├── MacPreview.swift             # Hardware frame renderer (MacBook Pro / Studio Display)
│   ├── ClockPreview.swift           # Clock view (Liquid Glass HUD, Retro Flip, Digital)
│   ├── WidgetCard.swift             # Glass widget components (Weather, Battery, SysInfo)
│   ├── GlassCard.swift              # Reusable frosted glass container
│   ├── InspectorSection.swift       # Standardized inspector UI card
│   └── SliderRow.swift              # Reusable formatted slider row
└── Views/
    ├── SidebarView.swift            # Studio navigation sidebar
    ├── PreviewView.swift            # Main interactive canvas toolbar & screen renderer
    ├── InspectorView.swift          # Router for contextual inspector tabs
    ├── OverviewInspectorView.swift  # Summary, quick presets & theme actions
    ├── WallpaperView.swift          # Wallpaper controls & Core Image sliders
    ├── ClockView.swift              # Clock style & typography selectors
    ├── WidgetsView.swift            # Widget toggles, placement & mock data editor
    ├── EffectsView.swift            # Lighting, vignette & retro texture controls
    ├── ThemesView.swift             # SwiftData theme library manager
    └── SettingsView.swift           # Frame mode, ratio & wallpaper export options
```

---

## 🛠️ Requirements

- **macOS**: 14.0 (Sonoma) or higher
- **Xcode**: 15.0 or higher
- **Swift**: 5.9+ / Swift 6 Ready

---

## 🚀 Getting Started

1. Clone or open the repository in Xcode:
   ```bash
   git clone https://github.com/your-username/LockScreenStudio.git
   cd "LockScreen Studio"
   open "LockScreen Studio.xcodeproj"
   ```

2. Select **My Mac** as the active run destination in Xcode.
3. Press **`⌘` + `R`** to build and run the application.

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for details.
