//
//  PortValues.swift
//  SwiftDataPlay
//
//  Created by Christian J Clampitt on 9/1/23.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    #if os(macOS)
    typealias SystemColor = NSColor
    #else
    typealias SystemColor = UIColor
    #endif

    var colorComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        #if os(macOS)
        SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        // Note that non RGB color will raise an exception, that I don't now how to catch because it is an Objc exception.
        #else
        guard SystemColor(self).getRed(&r, green: &g, blue: &b, alpha: &a) else {
            // Pay attention that the color should be convertible into RGB format
            // Colors using hue, saturation and brightness won't work
            return nil
        }
        #endif

        return (r, g, b, a)
    }

    var asRGBA: RGBA {
        if let components = colorComponents {
            return RGBA(red: components.red,
                        green: components.green,
                        blue: components.blue,
                        alpha: components.alpha)
        } else {
            // when can we fail to retrieve colors?
            fatalError()
        }
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)

        // Added
        let a = (try? container.decode(Double.self, forKey: .alpha)) ?? 1.0

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    public func encode(to encoder: Encoder) throws {
        guard let colorComponents = self.colorComponents else {
            return
        }

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(colorComponents.red, forKey: .red)
        try container.encode(colorComponents.green, forKey: .green)
        try container.encode(colorComponents.blue, forKey: .blue)
        try container.encode(colorComponents.alpha, forKey: .alpha)
    }
}

// https://stackoverflow.com/a/56874327/7170123
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


// The RGBa components of a color
struct RGBA: Equatable, Codable {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

    var toUIColor: UIColor {
        UIColor(red: self.red,
                green: self.green,
                blue: self.blue,
                alpha: self.alpha)
    }

    var toColor: Color {
        Color(uiColor: self.toUIColor)
    }

    func fromColor(_ color: Color) -> RGBA {
        color.asRGBA
    }

    func fromUIColor(_ uiColor: UIColor) -> RGBA {
        Color(uiColor: uiColor).asRGBA
    }
}

extension Color {
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self = RGBA(red: red,
                    green: green,
                    blue: blue,
                    alpha: alpha).toColor
    }

    init(rgba: RGBA) {
        self = rgba.toColor
    }
}

