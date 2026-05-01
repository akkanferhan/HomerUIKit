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

    /// Removes every arranged subview from the stack and detaches it
    /// from the regular view hierarchy.
    ///
    /// `UIStackView.removeArrangedSubview(_:)` only stops the stack from
    /// *arranging* a view; the view stays in ``UIView/subviews`` and
    /// remains visible at its last laid-out frame. This helper does
    /// both halves of the cleanup so the stack ends up empty — the
    /// equivalent UIKit idiom every consumer eventually reinvents.
    ///
    /// ```swift
    /// stack.removeAllArrangedSubviews()
    /// stack.addArrangedSubviews(model.rows.map(RowView.init))
    /// ```
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
