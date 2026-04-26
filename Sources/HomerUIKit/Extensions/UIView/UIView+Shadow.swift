import UIKit

@MainActor
public extension UIView {

    /// Applies a shadow style to the view's layer.
    ///
    /// Disables `clipsToBounds` (a clipped view cannot show its
    /// shadow). Does **not** generate a `shadowPath` — for best
    /// performance with rounded corners, prefer
    /// ``applyShadow(_:withCornerRadius:)``.
    ///
    /// - Parameter style: Shadow style to apply.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func applyShadow(_ style: ShadowStyle) -> Self {
        layer.shadowColor = style.color.uiColor.cgColor
        layer.shadowOpacity = style.opacity
        layer.shadowOffset = style.offset
        layer.shadowRadius = style.radius
        clipsToBounds = false
        return self
    }

    /// Applies a shadow style **and** sets `shadowPath` from the
    /// current bounds and corner radius.
    ///
    /// Configures the layer so a rounded card with a drop shadow
    /// works in one call: corner radius is set, `clipsToBounds` is
    /// disabled, and `shadowPath` is precomputed (avoids the
    /// off-screen render needed when no path is provided).
    ///
    /// > Important: The path is generated once from the bounds at
    /// > call time. After any bounds change you must call
    /// > ``updateShadowPathIfNeeded()`` to refresh the path. v0.2.0
    /// > will lift this requirement.
    ///
    /// - Parameters:
    ///   - style: Shadow style to apply.
    ///   - radius: Corner radius used to shape the shadow path.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func applyShadow(_ style: ShadowStyle, withCornerRadius radius: CornerRadius) -> Self {
        let resolved = radius.resolved(forHeight: bounds.height)
        layer.cornerRadius = resolved
        layer.cornerCurve = .continuous
        applyShadow(style)
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: resolved
        ).cgPath
        return self
    }

    /// Recomputes `layer.shadowPath` from the current bounds and the
    /// previously-applied corner radius.
    ///
    /// No-op if no shadow path was previously set (i.e. the view was
    /// configured via ``applyShadow(_:)`` rather than
    /// ``applyShadow(_:withCornerRadius:)``).
    ///
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func updateShadowPathIfNeeded() -> Self {
        guard layer.shadowPath != nil else { return self }
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: layer.cornerRadius
        ).cgPath
        return self
    }
}
