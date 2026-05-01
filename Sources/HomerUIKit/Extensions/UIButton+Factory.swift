import UIKit

@MainActor
public extension UIButton {

    /// Creates a button with `UIButton.Configuration.filled()` — solid
    /// tint background, white foreground.
    ///
    /// Use for the primary call-to-action on a screen ("Save",
    /// "Continue", "Sign in").
    ///
    /// ```swift
    /// let save = UIButton.filled(title: "Save", image: UIImage(systemName: "checkmark"))
    /// ```
    ///
    /// - Parameters:
    ///   - title: The button title, or `nil` for an icon-only button.
    ///   - image: Optional leading image (typically a SF Symbol).
    ///   - tintColor: Tint colour applied to the configuration's
    ///     `baseBackgroundColor`. Defaults to ``UIColor/tintColor``.
    /// - Returns: A configured `UIButton`.
    static func filled(
        title: String? = nil,
        image: UIImage? = nil,
        tintColor: UIColor = .tintColor
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = image
        config.baseBackgroundColor = tintColor
        let button = UIButton(configuration: config)
        button.tintColor = tintColor
        return button
    }

    /// Creates a button with `UIButton.Configuration.tinted()` — a
    /// translucent tint background that adapts to light / dark mode.
    ///
    /// Use for secondary actions paired with a ``filled(title:image:tintColor:)``
    /// primary button ("Cancel" alongside "Save", "Skip" alongside
    /// "Continue").
    ///
    /// - Parameters:
    ///   - title: The button title, or `nil` for an icon-only button.
    ///   - image: Optional leading image.
    ///   - tintColor: Tint colour. Defaults to ``UIColor/tintColor``.
    /// - Returns: A configured `UIButton`.
    static func tinted(
        title: String? = nil,
        image: UIImage? = nil,
        tintColor: UIColor = .tintColor
    ) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = title
        config.image = image
        config.baseForegroundColor = tintColor
        let button = UIButton(configuration: config)
        button.tintColor = tintColor
        return button
    }

    /// Creates a button with `UIButton.Configuration.plain()` — no
    /// background, just tinted text and / or image.
    ///
    /// Use for tertiary actions and inline links inside cells, headers,
    /// and footers.
    ///
    /// - Parameters:
    ///   - title: The button title, or `nil` for an icon-only button.
    ///   - image: Optional leading image.
    ///   - tintColor: Foreground colour. Defaults to ``UIColor/tintColor``.
    /// - Returns: A configured `UIButton`.
    static func plain(
        title: String? = nil,
        image: UIImage? = nil,
        tintColor: UIColor = .tintColor
    ) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.baseForegroundColor = tintColor
        let button = UIButton(configuration: config)
        button.tintColor = tintColor
        return button
    }

    /// Creates a button with `UIButton.Configuration.bordered()` — a
    /// neutral grey background with a subtle border.
    ///
    /// Use as a low-emphasis alternative to ``tinted(title:image:tintColor:)``
    /// when the button must stay quiet against the surrounding content.
    ///
    /// - Parameters:
    ///   - title: The button title, or `nil` for an icon-only button.
    ///   - image: Optional leading image.
    /// - Returns: A configured `UIButton`.
    static func bordered(
        title: String? = nil,
        image: UIImage? = nil
    ) -> UIButton {
        var config = UIButton.Configuration.bordered()
        config.title = title
        config.image = image
        return UIButton(configuration: config)
    }
}
