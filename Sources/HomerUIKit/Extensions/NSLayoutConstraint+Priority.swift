import UIKit

@MainActor
public extension NSLayoutConstraint {

    /// Sets the constraint's `priority` and returns `self` so the
    /// new value can flow into a fluent constraint declaration.
    ///
    /// Useful when several constraints would otherwise conflict and
    /// the caller wants the layout engine to pick the highest-priority
    /// satisfiable subset — typical for "preferred but compressible"
    /// width / height rules.
    ///
    /// ```swift
    /// view.heightAnchor
    ///     .constraint(equalToConstant: 200)
    ///     .withPriority(.defaultLow)
    ///     .isActive = true
    /// ```
    ///
    /// > Important: `priority` must not be raised above
    /// > `.required` once a constraint is installed in a window.
    /// > Use this helper before activation, or only when the value
    /// > you assign is below `.required`.
    ///
    /// - Parameter priority: The new priority.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
