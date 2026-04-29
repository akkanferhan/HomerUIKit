import UIKit

@MainActor
public extension UIImageView {

    /// Creates an image view configured for `scaleAspectFill` content
    /// with `clipsToBounds = true`, an optional corner radius, and a
    /// placeholder background colour.
    ///
    /// The cropping behaviour and placeholder colour together cover
    /// the typical "thumbnail tile" use case where the underlying
    /// image is loaded asynchronously and the view should already
    /// reserve a visible footprint.
    ///
    /// ```swift
    /// let thumbnail = UIImageView.aspectFill()
    /// let avatar = UIImageView.aspectFill(cornerRadius: 16)
    /// ```
    ///
    /// - Parameters:
    ///   - cornerRadius: Corner radius applied to `layer.cornerRadius`.
    ///     Values `<= 0` skip the assignment and leave the layer
    ///     untouched. Defaults to `0`.
    ///   - backgroundColor: Background colour shown while the image
    ///     is `nil`. Defaults to ``UIColor/secondarySystemBackground``.
    /// - Returns: A configured `UIImageView`.
    static func aspectFill(
        cornerRadius: CGFloat = 0,
        backgroundColor: UIColor = .secondarySystemBackground
    ) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = backgroundColor
        if cornerRadius > 0 {
            view.layer.cornerRadius = cornerRadius
        }
        return view
    }
}
