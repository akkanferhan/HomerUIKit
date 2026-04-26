import UIKit

@MainActor
public extension UIView {

    /// Applies a token-based corner radius to the view's layer and
    /// enables clipping so the view's content respects the rounded
    /// shape.
    ///
    /// For ``CornerRadius/pill`` the radius is computed from the
    /// current `bounds.height`; if you resize the view later you must
    /// re-apply this method.
    ///
    /// > Tip: If you also want a shadow, use
    /// > ``applyShadow(_:withCornerRadius:)`` instead — a shadow is
    /// > clipped away when `clipsToBounds` is `true`, which this
    /// > method enables.
    ///
    /// - Parameter radius: The corner-radius token to apply.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func cornerRadius(_ radius: CornerRadius) -> Self {
        layer.cornerRadius = radius.resolved(forHeight: bounds.height)
        layer.cornerCurve = .continuous
        clipsToBounds = true
        return self
    }

    /// Applies a raw point value as the layer's corner radius and
    /// enables clipping.
    ///
    /// Provided as an escape hatch for one-off values; prefer
    /// ``cornerRadius(_:)-(CornerRadius)`` with a token where
    /// possible.
    ///
    /// - Parameter raw: Point value to assign to
    ///   `layer.cornerRadius`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func cornerRadius(_ raw: CGFloat) -> Self {
        layer.cornerRadius = max(0, raw)
        layer.cornerCurve = .continuous
        clipsToBounds = true
        return self
    }

    /// Rounds only the specified corners using `layer.maskedCorners`.
    ///
    /// Uses the modern `CACornerMask` path; this composes correctly
    /// across resizes and avoids the legacy `CAShapeLayer` mask
    /// approach.
    ///
    /// - Parameters:
    ///   - corners: A `CACornerMask` selecting which corners to
    ///     round.
    ///   - radius: The radius token to apply to the selected corners.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func roundedCorners(_ corners: CACornerMask, radius: CornerRadius) -> Self {
        layer.cornerRadius = radius.resolved(forHeight: bounds.height)
        layer.cornerCurve = .continuous
        layer.maskedCorners = corners
        clipsToBounds = true
        return self
    }
}
