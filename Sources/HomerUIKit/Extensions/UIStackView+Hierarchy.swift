import UIKit

@MainActor
public extension UIStackView {

    /// Adds multiple arranged subviews in declaration order.
    ///
    /// Equivalent to calling `addArrangedSubview(_:)` once per
    /// element. The final element ends up at the trailing edge of
    /// the stack along its axis.
    ///
    /// - Parameter views: A variadic list of views to add.
    func addArrangedSubviews(_ views: UIView...) {
        addArrangedSubviews(views)
    }

    /// Adds multiple arranged subviews in declaration order.
    ///
    /// Provided alongside the variadic overload so callers can
    /// forward an existing `[UIView]` without spreading it.
    ///
    /// - Parameter views: An array of views to add.
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
