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
}
