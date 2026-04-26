import UIKit

@MainActor
public extension UIView {

    /// Adds multiple subviews in declaration order.
    ///
    /// Equivalent to calling `addSubview(_:)` once per element. The
    /// final element ends up on top of the z-order, matching UIKit's
    /// own semantics.
    ///
    /// - Parameter views: A variadic list of views to add.
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }

    /// Adds multiple subviews in declaration order.
    ///
    /// Provided alongside the variadic overload so callers can
    /// forward an existing `[UIView]` without spreading it.
    ///
    /// - Parameter views: An array of views to add.
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
