//
//  EffectsConfiguration.swift
//  LockScreen Studio
//

import SwiftUI

struct EffectsConfiguration: Codable, Hashable, Equatable {
    var vignette: Double = 0.15           // 0.0 to 1.0
    var filmGrain: Double = 0.0           // 0.0 to 1.0
    var colorTintEnabled: Bool = false
    var colorTint: CodableColor = .blue
    var tintIntensity: Double = 0.20      // 0.0 to 1.0
    var frostedGlassOverlay: Double = 0.0 // 0.0 to 1.0
    var dimmingLevel: Double = 0.10       // 0.0 to 0.8
    var crtScanlines: Bool = false

    static var defaultConfiguration: EffectsConfiguration {
        EffectsConfiguration()
    }
}
