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
        let trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let stripped: String
        if trimmed.hasPrefix("#") {
            stripped = String(trimmed.dropFirst())
        } else {
            stripped = trimmed
        }

        guard stripped.count == 6 || stripped.count == 8 else { return nil }
        guard stripped.allSatisfy({ $0.isHexDigit }) else { return nil }

        var value: UInt64 = 0
        Scanner(string: stripped).scanHexInt64(&value)

        let red, green, blue, alpha: CGFloat
        if stripped.count == 8 {
            red = CGFloat((value & 0xFF00_0000) >> 24) / 255
            green = CGFloat((value & 0x00FF_0000) >> 16) / 255
            blue = CGFloat((value & 0x0000_FF00) >> 8) / 255
            alpha = CGFloat(value & 0x0000_00FF) / 255
        } else {
            red = CGFloat((value & 0xFF_0000) >> 16) / 255
            green = CGFloat((value & 0x00_FF00) >> 8) / 255
            blue = CGFloat(value & 0x00_00FF) / 255
            alpha = 1
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
