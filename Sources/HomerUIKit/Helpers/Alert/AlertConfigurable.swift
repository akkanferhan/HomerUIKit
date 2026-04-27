import UIKit

/// Describes the data used to build a `UIAlertController`.
///
/// Conform a value type to `AlertConfigurable` and pass it to
/// ``AlertShowable/presentAlert(with:)`` (or ``AlertShowable/showAlert(with:)``
/// when the receiver is a `UIViewController`) to get a configured
/// alert on screen without manually wiring up `UIAlertController`
/// every time.
///
/// The protocol is `@MainActor` because `UIAlertAction` is itself
/// main-actor isolated under Swift 6 strict concurrency.
@MainActor
public protocol AlertConfigurable {

    /// The presentation style — `.alert` or `.actionSheet`.
    var style: UIAlertController.Style { get }

    /// Optional title displayed at the top of the alert.
    var title: String? { get }

    /// Optional body text displayed below the title.
    var message: String? { get }

    /// Actions (buttons) attached to the alert, in display order.
    var actions: [UIAlertAction] { get }
}
