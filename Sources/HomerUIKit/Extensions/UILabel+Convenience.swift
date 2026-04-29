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

    /// Creates a label preconfigured for Dynamic Type:
    /// `preferredFont(forTextStyle:)` plus
    /// `adjustsFontForContentSizeCategory = true`.
    ///
    /// Prefer this factory over the generic
    /// ``init(text:font:textColor:textAlignment:numberOfLines:)`` when
    /// the label needs to scale with the user's content size
    /// preferences — accessibility callers rely on it.
    ///
    /// ```swift
    /// let title = UILabel.dynamicType(style: .headline)
    /// let caption = UILabel.dynamicType(
    ///     style: .footnote,
    ///     color: .secondaryLabel,
    ///     numberOfLines: 2,
    ///     textAlignment: .center
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - style: The Dynamic Type text style driving the label's font.
    ///   - color: Text colour, defaulting to ``UIColor/label``.
    ///   - numberOfLines: Maximum line count; `0` allows unlimited
    ///     wrapping. Defaults to `0` (multi-line) since most Dynamic
    ///     Type labels need to wrap at larger content sizes.
    ///   - textAlignment: Horizontal alignment, defaulting to
    ///     ``NSTextAlignment/natural``.
    /// - Returns: A configured `UILabel`.
    static func dynamicType(
        style: UIFont.TextStyle,
        color: UIColor = .label,
        numberOfLines: Int = 0,
        textAlignment: NSTextAlignment = .natural
    ) -> UILabel {
        let label = UILabel(
            font: .preferredFont(forTextStyle: style),
            textColor: color,
            textAlignment: textAlignment,
            numberOfLines: numberOfLines
        )
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}
