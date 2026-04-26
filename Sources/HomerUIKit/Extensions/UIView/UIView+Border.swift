import UIKit

@MainActor
public extension UIView {

    /// Applies a token-based border to the view's layer.
    ///
    /// > Important: This is a one-shot operation in v0.1.0. The
    /// > resolved `borderColor` does **not** automatically refresh
    /// > on trait collection changes (e.g. light/dark mode). If you
    /// > need that behaviour, re-apply the border in
    /// > `traitCollectionDidChange(_:)`.
    ///
    /// - Parameter style: Border style to apply.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func border(_ style: BorderStyle) -> Self {
        layer.borderWidth = style.width
        layer.borderColor = style.color.uiColor.cgColor
        return self
    }

    /// Escape-hatch border applying a raw width and a fully-resolved
    /// `UIColor`. Same caveats about dark-mode refresh apply.
    ///
    /// - Parameters:
    ///   - width: Stroke width in points.
    ///   - color: Fully-resolved stroke colour.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func border(width: CGFloat, color: UIColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
}
