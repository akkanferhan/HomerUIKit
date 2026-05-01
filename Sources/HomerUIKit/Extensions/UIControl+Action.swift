import UIKit

@MainActor
public extension UIControl {

    /// Closure-based wrapper around `addAction(_:for:)` (iOS 14+) so
    /// `UIControl` events can be handled without the target / action
    /// selector dance.
    ///
    /// Internally creates a `UIAction` whose handler bridges to a
    /// `@MainActor` closure via `MainActor.assumeIsolated`, matching the
    /// concurrency contract used by ``UIView/animate(_:animations:completion:)``.
    /// Capture references weakly when the receiver and the captured
    /// object would form a retain cycle — `UIControl` keeps a strong
    /// reference to every registered `UIAction`.
    ///
    /// ```swift
    /// button.addAction(for: .touchUpInside) { [weak self] _ in
    ///     self?.handleTap()
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - event: The control event(s) the handler should respond to.
    ///   - handler: Closure invoked with the originating `UIAction`.
    ///     `UIAction.sender` exposes the control that fired it.
    /// - Returns: The created `UIAction` so callers can later remove it
    ///   via `removeAction(_:for:)`.
    @discardableResult
    func addAction(
        for event: UIControl.Event,
        _ handler: @escaping @MainActor (UIAction) -> Void
    ) -> UIAction {
        let action = UIAction { action in
            MainActor.assumeIsolated { handler(action) }
        }
        addAction(action, for: event)
        return action
    }
}
