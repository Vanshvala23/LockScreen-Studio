//
//  CodableColor.swift
//  LockScreen Studio
//

import SwiftUI
import AppKit

struct CodableColor: Codable, Hashable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(color: Color) {
        let nsColor = NSColor(color).usingColorSpace(.sRGB) ?? .white
        self.red = Double(nsColor.redComponent)
        self.green = Double(nsColor.greenComponent)
        self.blue = Double(nsColor.blueComponent)
        self.alpha = Double(nsColor.alphaComponent)
    }

    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    static let white = CodableColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let black = CodableColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let blue = CodableColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0)
    static let cyan = CodableColor(red: 0.188, green: 0.816, blue: 0.988, alpha: 1.0)
    static let orange = CodableColor(red: 1.0, green: 0.584, blue: 0.0, alpha: 1.0)
    static let purple = CodableColor(red: 0.686, green: 0.322, blue: 0.871, alpha: 1.0)
    static let pink = CodableColor(red: 1.0, green: 0.176, blue: 0.333, alpha: 1.0)
    static let green = CodableColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1.0)
}
