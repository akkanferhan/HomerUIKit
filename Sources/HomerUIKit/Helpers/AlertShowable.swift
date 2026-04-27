import UIKit

/// A capability for presenting alerts described by
/// ``AlertConfigurable``.
///
/// Adopt `AlertShowable` on coordinators, managers, or any
/// non-`UIViewController` type that needs to surface an alert. The
/// default ``presentAlert(with:)`` implementation forwards to
/// ``AlertManager/shared``, which queues concurrent requests and
/// shows them serially in a dedicated window above the application's
/// content — so multiple call sites firing at once no longer drop
/// alerts on the floor.
///
/// `UIViewController` types that adopt `AlertShowable` get a second
/// method, ``showAlert(with:)``, which presents on `self` directly
/// (bypassing the manager's queue and window). Use it only when you
/// own the presenter's lifecycle and explicitly want the alert
/// scoped to that view-controller's hierarchy.
@MainActor
public protocol AlertShowable {

    /// Enqueues an alert on ``AlertManager/shared``. The manager
    /// presents the alert in its own window above any current
    /// content, and serialises concurrent requests so no two alerts
    /// race for the same presenter.
    ///
    /// - Parameter configuration: The alert configuration.
    func presentAlert(with configuration: any AlertConfigurable)
}

public extension AlertShowable {

    func presentAlert(with configuration: any AlertConfigurable) {
        AlertManager.shared.enqueue(configuration)
    }
}

public extension AlertShowable where Self: UIViewController {

    /// Presents the alert on the receiver itself, bypassing
    /// ``AlertManager``'s queue and dedicated window.
    ///
    /// Use this when you already have a presenter in hand and want
    /// the alert to remain a child of `self`'s presentation
    /// hierarchy. Note that calls made while another presentation is
    /// active on `self` are silently dropped by UIKit — for that
    /// reason ``presentAlert(with:)`` is preferred.
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
