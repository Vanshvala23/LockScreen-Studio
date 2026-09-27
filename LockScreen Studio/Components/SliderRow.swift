//
//  SliderRow.swift
//  LockScreen Studio
//

import SwiftUI

struct SliderRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let format: String
    var scale: Double = 1.0

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: format, value * scale))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.primary)
            }

            Slider(value: $value, in: range)
        }
    }
}

#Preview("Slider Row") {
    struct PreviewWrapper: View {
        @State private var val: Double = 0.75

        var body: some View {
            SliderRow(label: "Vignette Intensity", value: $val, range: 0...1, format: "%.0f%%", scale: 100)
                .padding()
                .frame(width: 300)
        }
    }

    return PreviewWrapper()
}
