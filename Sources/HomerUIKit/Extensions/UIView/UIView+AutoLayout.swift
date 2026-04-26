import HomerFoundation
import UIKit

@MainActor
public extension UIView {

    /// Pins all four edges of the receiver to its superview's edges
    /// with the given insets and activates the constraints.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false` on
    /// the receiver. If the receiver has no superview, logs a
    /// warning and returns without activating anything.
    ///
    /// - Parameter insets: Edge insets, defaulting to `.zero`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperview(insets: UIEdgeInsets = .zero) -> Self {
        guard let superview else {
            log.warning("pinToSuperview called on a view with no superview")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
        return self
    }

    /// Convenience that pins all four edges with an equal token-based
    /// inset on every side.
    ///
    /// - Parameter spacing: A spacing token applied to all four
    ///   edges.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperview(spacing: Spacing) -> Self {
        pinToSuperview(insets: UIEdgeInsets(all: spacing))
    }

    /// Pins all four edges of the receiver to its superview's
    /// `safeAreaLayoutGuide` with the given insets.
    ///
    /// - Parameter insets: Edge insets, defaulting to `.zero`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperviewSafeArea(insets: UIEdgeInsets = .zero) -> Self {
        guard let superview else {
            log.warning("pinToSuperviewSafeArea called on a view with no superview")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        let safe = superview.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safe.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -insets.bottom)
        ])
        return self
    }

    /// Pins all four edges to the superview's safe area with an
    /// equal token-based inset on every side.
    ///
    /// - Parameter spacing: A spacing token applied to all four
    ///   edges.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperviewSafeArea(spacing: Spacing) -> Self {
        pinToSuperviewSafeArea(insets: UIEdgeInsets(all: spacing))
    }

    /// Centers the receiver in its superview by activating
    /// `centerXAnchor` and `centerYAnchor` constraints.
    ///
    /// If the receiver has no superview, logs a warning and returns
    /// without activating anything.
    ///
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func centerInSuperview() -> Self {
        guard let superview else {
            log.warning("centerInSuperview called on a view with no superview")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
        return self
    }
}
