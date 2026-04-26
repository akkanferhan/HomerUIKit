import UIKit

@MainActor
public extension UIView {

    /// The inverse of `isHidden`, expressed positively.
    ///
    /// Reading `isVisible` returns `!isHidden`; assigning `true`
    /// reveals the view, assigning `false` hides it. Useful when the
    /// surrounding code reads more naturally with positive-sense
    /// boolean expressions (e.g. `header.isVisible = hasUnreadItems`).
    ///
    /// Note that `isVisible == true` does **not** guarantee the view
    /// is on screen — it only mirrors `!isHidden`. A view can be
    /// "visible" yet detached from the window hierarchy, transparent,
    /// or covered by another view.
    var isVisible: Bool {
        get { !isHidden }
        set { isHidden = !newValue }
    }

    /// Hides the receiver and returns it for chaining.
    ///
    /// Equivalent to setting `isHidden = true`.
    ///
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func hide() -> Self {
        isHidden = true
        return self
    }

    /// Reveals the receiver and returns it for chaining.
    ///
    /// Equivalent to setting `isHidden = false`.
    ///
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func show() -> Self {
        isHidden = false
        return self
    }
}
