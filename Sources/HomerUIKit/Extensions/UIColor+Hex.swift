import HomerFoundation
import UIKit

public extension UIColor {

    /// Parses a 6- or 8-character hex string into a `UIColor`.
    ///
    /// Supported formats (an optional leading `#` is accepted):
    /// - `"RRGGBB"` — RGB; alpha defaults to `1`.
    /// - `"RRGGBBAA"` — RGBA, alpha component last (CSS-style).
    ///
    /// Whitespace at either end is trimmed. Returns `nil` for any
    /// other length, for characters outside `0-9A-Fa-f`, or for an
    /// empty input.
    ///
    /// ```swift
    /// let brand = UIColor(hex: "#FF6F00")            // RGB
    /// let glassy = UIColor(hex: "FF6F0080")          // RGBA, 50% alpha
    /// let invalid = UIColor(hex: "not a color")      // nil
    /// ```
    ///
    /// - Parameter hex: The hex string to parse.
    convenience init?(hex: String) {
        let trimmed = hex.whitespaceTrimmed
        let stripped: String
        if trimmed.hasPrefix(HexParser.hashPrefix) {
            stripped = String(trimmed.dropFirst())
        } else {
            stripped = trimmed
        }

        guard
            stripped.count == HexParser.rgbLength || stripped.count == HexParser.rgbaLength
        else {
            return nil
        }
        guard stripped.allSatisfy({ $0.isHexDigit }) else { return nil }

        var value: UInt64 = 0
        Scanner(string: stripped).scanHexInt64(&value)

        let red, green, blue, alpha: CGFloat
        if stripped.count == HexParser.rgbaLength {
            red = CGFloat((value & HexParser.rgbaRedMask) >> HexParser.rgbaRedShift) / HexParser.componentMax
            green = CGFloat((value & HexParser.rgbaGreenMask) >> HexParser.rgbaGreenShift) / HexParser.componentMax
            blue = CGFloat((value & HexParser.rgbaBlueMask) >> HexParser.rgbaBlueShift) / HexParser.componentMax
            alpha = CGFloat(value & HexParser.rgbaAlphaMask) / HexParser.componentMax
        } else {
            red = CGFloat((value & HexParser.rgbRedMask) >> HexParser.rgbRedShift) / HexParser.componentMax
            green = CGFloat((value & HexParser.rgbGreenMask) >> HexParser.rgbGreenShift) / HexParser.componentMax
            blue = CGFloat(value & HexParser.rgbBlueMask) / HexParser.componentMax
            alpha = 1
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - Internal constants

private enum HexParser {
    static let hashPrefix = "#"
    static let rgbLength = 6
    static let rgbaLength = 8
    static let componentMax: CGFloat = 255

    // RGBA (8-char) bit masks and shifts.
    static let rgbaRedMask: UInt64 = 0xFF00_0000
    static let rgbaRedShift: UInt64 = 24
    static let rgbaGreenMask: UInt64 = 0x00FF_0000
    static let rgbaGreenShift: UInt64 = 16
    static let rgbaBlueMask: UInt64 = 0x0000_FF00
    static let rgbaBlueShift: UInt64 = 8
    static let rgbaAlphaMask: UInt64 = 0x0000_00FF

    // RGB (6-char) bit masks and shifts.
    static let rgbRedMask: UInt64 = 0xFF_0000
    static let rgbRedShift: UInt64 = 16
    static let rgbGreenMask: UInt64 = 0x00_FF00
    static let rgbGreenShift: UInt64 = 8
    static let rgbBlueMask: UInt64 = 0x00_00FF
}
