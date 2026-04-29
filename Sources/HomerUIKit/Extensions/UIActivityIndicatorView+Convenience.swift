import UIKit

@MainActor
public extension UIActivityIndicatorView {

    /// Creates an activity indicator with the given style, tint
    /// colour, and stop behaviour bundled into a single call.
    ///
    /// ```swift
    /// let spinner = UIActivityIndicatorView.make()
    /// let footer = UIActivityIndicatorView.make(hidesWhenStopped: false)
    /// ```
    ///
    /// - Parameters:
    ///   - style: The indicator style, defaulting to ``Style/medium``.
    ///   - color: The indicator tint colour, defaulting to
    ///     ``UIColor/systemGray``.
    ///   - hidesWhenStopped: Whether the indicator should disappear
    ///     when not animating. Defaults to `true`, matching UIKit's
    ///     own default.
    /// - Returns: A configured `UIActivityIndicatorView`.
    static func make(
        style: Style = .medium,
        color: UIColor = .systemGray,
        hidesWhenStopped: Bool = true
    ) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        indicator.hidesWhenStopped = hidesWhenStopped
        return indicator
    }
}
