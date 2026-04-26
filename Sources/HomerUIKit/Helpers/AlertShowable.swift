import UIKit

/// A capability for presenting alerts described by
/// ``AlertConfigurable``.
///
/// Adopt `AlertShowable` on coordinators, managers, or any
/// non-`UIViewController` type that needs to surface an alert. The
/// default implementation looks up the application's top-most view
/// controller via
/// ``UIKit/UIApplication/topMostViewController`` and presents on it;
/// if no foreground-active scene is available, the call is a no-op.
///
/// `UIViewController` types that adopt `AlertShowable` get a second
/// method, ``showAlert(with:)``, which presents on `self` instead of
/// hopping to the top-most view controller — useful when you control
/// the presenter and want to keep the alert attached to your screen.
@MainActor
public protocol AlertShowable {

    /// Presents an alert on the application's top-most view
    /// controller. No-op if no key window is available.
    ///
    /// - Parameter configuration: The alert configuration.
    func presentAlert(with configuration: any AlertConfigurable)
}

public extension AlertShowable {

    func presentAlert(with configuration: any AlertConfigurable) {
        guard let host = UIApplication.shared.topMostViewController else { return }
        presentAlertController(for: configuration, on: host)
    }
}

public extension AlertShowable where Self: UIViewController {

    /// Presents the alert on the receiver itself rather than the
    /// top-most view controller.
    ///
    /// Use this when you already have a presenter in hand and want
    /// the alert to remain a child of `self`'s presentation hierarchy.
    ///
    /// - Parameter configuration: The alert configuration.
    func showAlert(with configuration: any AlertConfigurable) {
        presentAlertController(for: configuration, on: self)
    }
}

@MainActor
private func presentAlertController(
    for configuration: any AlertConfigurable,
    on viewController: UIViewController
) {
    let alertController = UIAlertController(
        title: configuration.title,
        message: configuration.message,
        preferredStyle: configuration.style
    )
    for action in configuration.actions {
        alertController.addAction(action)
    }
    if let popover = alertController.popoverPresentationController {
        let host = viewController.view
        popover.sourceView = host
        if let host {
            popover.sourceRect = CGRect(
                x: host.bounds.midX,
                y: host.bounds.midY,
                width: 0,
                height: 0
            )
        }
        popover.permittedArrowDirections = []
    }
    viewController.present(alertController, animated: true)
}
