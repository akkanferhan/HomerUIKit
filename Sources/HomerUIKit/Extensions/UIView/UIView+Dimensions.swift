import UIKit

@MainActor
public extension UIView {

    /// Pins the receiver's width to a fixed point value and activates
    /// the constraint.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`. The
    /// resulting constraint is added to the receiver itself.
    ///
    /// - Parameter width: Fixed width in points.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func setWidth(_ width: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }

    /// Pins the receiver's height to a fixed point value and
    /// activates the constraint.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`. The
    /// resulting constraint is added to the receiver itself.
    ///
    /// - Parameter height: Fixed height in points.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func setHeight(_ height: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }

    /// Pins both width and height to fixed point values.
    ///
    /// Equivalent to chaining ``setWidth(_:)`` and ``setHeight(_:)``.
    ///
    /// - Parameters:
    ///   - width: Fixed width in points.
    ///   - height: Fixed height in points.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func setSize(width: CGFloat, height: CGFloat) -> Self {
        setWidth(width)
        setHeight(height)
        return self
    }

    /// Sets a minimum height (`>=`) on the receiver and activates the
    /// constraint.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`.
    ///
    /// - Parameter height: Minimum height in points.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func setMinimumHeight(_ height: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        return self
    }

    /// Pins the receiver's width to another view's width and
    /// activates the constraint.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`. The
    /// other view does not need to be a sibling — any view that
    /// shares a layout hierarchy works. Use this to keep two
    /// independently-positioned views the same width across
    /// rotations and dynamic-type changes.
    ///
    /// ```swift
    /// // Two columns that always match each other.
    /// rightColumn.setWidth(equalTo: leftColumn)
    /// ```
    ///
    /// - Parameter view: The reference view whose `widthAnchor`
    ///   the receiver should match.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func setWidth(equalTo view: UIView) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        return self
    }

    /// Pins the receiver's height to another view's height and
    /// activates the constraint.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`. The
    /// other view does not need to be a sibling — any view that
    /// shares a layout hierarchy works. Symmetric counterpart to
    /// ``setWidth(equalTo:)`` for vertical pairings such as a
    /// scroll view's content view inheriting the scroll view's
    /// own height.
    ///
    /// ```swift
    /// // Image view that always matches the scroll view's height
    /// // (used for centred-zoom layouts).
    /// imageView.setHeight(equalTo: scrollView)
    /// ```
    ///
    /// - Parameter view: The reference view whose `heightAnchor`
    ///   the receiver should match.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func setHeight(equalTo view: UIView) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        return self
    }

    /// Constrains the receiver's width to be a multiple of its
    /// height, activates the constraint, and returns it for further
    /// tweaking.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`.
    /// Pass `1.0` for a square, `16.0 / 9.0` for landscape video,
    /// `4.0 / 3.0` for legacy photo, etc. The returned constraint
    /// is activated; mutate its `priority` later to soften the
    /// rule, or replace it entirely to animate ratio changes.
    ///
    /// - Parameter ratio: Width / height multiplier.
    /// - Returns: The activated aspect-ratio constraint.
    @discardableResult
    func setAspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio)
        constraint.isActive = true
        return constraint
    }
}
