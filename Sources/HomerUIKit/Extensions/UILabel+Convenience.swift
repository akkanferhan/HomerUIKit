import UIKit

@MainActor
public extension UILabel {

    /// Convenience initializer that bundles the most common label
    /// configuration into a single call.
    ///
    /// All parameters are optional; omitted ones fall back to
    /// `UILabel`'s defaults. The text alignment defaults to
    /// `.natural` (matches the user's writing direction), and
    /// `numberOfLines` defaults to `1` to match UIKit.
    ///
    /// ```swift
    /// let title = UILabel(
    ///     text: "Welcome",
    ///     font: .preferredFont(forTextStyle: .title2),
    ///     textColor: .label,
    ///     textAlignment: .center,
    ///     numberOfLines: 0
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - text: The text to display, or `nil` for an empty label.
    ///   - font: The font, or `nil` to keep the system default
    ///     (`UIFont.systemFont(ofSize: UIFont.labelFontSize)`).
    ///   - textColor: The foreground colour, or `nil` for the system
    ///     default (`.label`).
    ///   - textAlignment: Horizontal alignment, defaulting to
    ///     ``NSTextAlignment.natural``.
    ///   - numberOfLines: Maximum line count; `0` allows unlimited
    ///     wrapping. Defaults to `1`.
    convenience init(
        text: String? = nil,
        font: UIFont? = nil,
        textColor: UIColor? = nil,
        textAlignment: NSTextAlignment = .natural,
        numberOfLines: Int = 1
    ) {
        self.init(frame: .zero)
        self.text = text
        if let font {
            self.font = font
        }
        if let textColor {
            self.textColor = textColor
        }
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
