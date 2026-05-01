import UIKit

@MainActor
public extension UIView {

    /// Adds the supplied view as a subview and pins all four edges to
    /// the receiver's edges with the given insets.
    ///
    /// Equivalent to:
    ///
    /// ```swift
    /// receiver.addSubview(child)
    /// child.pinToSuperview(insets: insets)
    /// ```
    ///
    /// — but written as a single call so callers can read containment
    /// + layout as one step.
    ///
    /// ```swift
    /// container.embed(card, insets: UIEdgeInsets(all: .medium))
    /// ```
    ///
    /// - Parameters:
    ///   - child: The view to embed.
    ///   - insets: Edge insets applied via ``pinToSuperview(insets:)``.
    ///     Defaults to `.zero`.
    /// - Returns: The embedded child view, so calls can be chained or
    ///   captured inline for further configuration.
    @discardableResult
    func embed(_ child: UIView, insets: UIEdgeInsets = .zero) -> UIView {
        addSubview(child)
        child.pinToSuperview(insets: insets)
        return child
    }

    /// Adds the supplied view as a subview and pins it with an equal
    /// token-based inset on every edge.
    ///
    /// - Parameters:
    ///   - child: The view to embed.
    ///   - spacing: A ``Spacing`` token applied to all four edges.
    /// - Returns: The embedded child view.
    @discardableResult
    func embed(_ child: UIView, spacing: Spacing) -> UIView {
        embed(child, insets: UIEdgeInsets(all: spacing))
    }

    /// Removes every subview from the receiver in declaration order.
    ///
    /// Useful for "rebuild from scratch" reload paths where a host view
    /// owns a transient set of subviews that depend on a model snapshot.
    /// Iterates the snapshotted ``subviews`` array, so removals during
    /// iteration are safe.
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}
