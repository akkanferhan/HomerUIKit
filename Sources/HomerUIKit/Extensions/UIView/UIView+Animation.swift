import UIKit

@MainActor
public extension UIView {

    /// Token-based wrapper around `UIView.animate(withDuration:animations:completion:)`.
    ///
    /// Accepts an ``AnimationDuration`` token instead of a raw
    /// `TimeInterval` so animation timing flows through the design
    /// system rather than getting hard-coded at every call site.
    ///
    /// ```swift
    /// UIView.animate(.fast) {
    ///     overlay.alpha = 0
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - duration: The duration token to resolve.
    ///   - animations: The closure containing animatable property
    ///     changes.
    ///   - completion: Optional completion handler invoked with
    ///     `finished == true` if the animation ran to completion. The
    ///     closure is `@MainActor` because the callback is delivered
    ///     on the main thread.
    ///
    /// > Note: The closures keep their inline `() -> Void` /
    /// > `(Bool) -> Void` shapes rather than being expressed via
    /// > HomerFoundation's `VoidCompletion` / `ValueCompletion<T>`
    /// > typealiases. Swift does not allow function-type attributes
    /// > (`@MainActor`, `@escaping`) to be layered on top of a
    /// > typealiased function type, so a `@MainActor`-isolated
    /// > closure cannot be expressed as `@MainActor VoidCompletion`.
    static func animate(
        _ duration: AnimationDuration,
        animations: @MainActor @escaping () -> Void,
        completion: (@MainActor (Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration.value,
            animations: animations,
            completion: completion.map { handler in
                { finished in
                    MainActor.assumeIsolated { handler(finished) }
                }
            }
        )
    }
}
