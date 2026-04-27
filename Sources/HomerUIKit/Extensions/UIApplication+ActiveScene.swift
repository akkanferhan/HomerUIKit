import UIKit

@MainActor
public extension UIApplication {

    /// The first connected `UIWindowScene` whose activation state is
    /// `.foregroundActive`, or `nil` when no scene is currently in
    /// the foreground.
    ///
    /// Use this when constructing a `UIWindow` that should live in
    /// the user's currently visible scene — modal overlays, alert
    /// windows, debug HUDs. Returns `nil` during launch, while the
    /// app is backgrounded, and inside unit-test targets that have
    /// no scene wired up.
    var activeForegroundWindowScene: UIWindowScene? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}
