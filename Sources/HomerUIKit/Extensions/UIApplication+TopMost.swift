import UIKit

@MainActor
public extension UIApplication {

    /// The visible top-most view controller of the application.
    ///
    /// Walks the foreground-active scene's key window and unwraps
    /// `presentedViewController`, `UINavigationController.visibleViewController`,
    /// and `UITabBarController.selectedViewController` to reach the
    /// view controller the user is actually looking at.
    ///
    /// Returns `nil` when no foreground-active scene exists (e.g.
    /// during launch or in a unit-test target without a window).
    var topMostViewController: UIViewController? {
        guard
            let scene = connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
            let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return nil
        }
        return Self.topMost(from: root)
    }

    /// Recursively unwraps presentation, navigation, and tab-bar
    /// containers to find the actually-visible view controller below
    /// the given root.
    ///
    /// Internal so the recursion logic is unit-testable without
    /// constructing a full window scene.
    internal static func topMost(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return topMost(from: presented)
        }
        if let nav = viewController as? UINavigationController,
           let visible = nav.visibleViewController {
            return topMost(from: visible)
        }
        if let tab = viewController as? UITabBarController,
           let selected = tab.selectedViewController {
            return topMost(from: selected)
        }
        return viewController
    }
}
