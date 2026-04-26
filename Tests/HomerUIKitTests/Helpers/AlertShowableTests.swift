import Testing
import UIKit
@testable import HomerUIKit

@MainActor
private final class CapturingHost: UIViewController, AlertShowable {
    var captured: UIViewController?

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        captured = viewControllerToPresent
    }
}

private struct TestAlertConfig: AlertConfigurable {
    let style: UIAlertController.Style
    let title: String?
    let message: String?
    let actions: [UIAlertAction]
}

@Suite("AlertShowable")
@MainActor
struct AlertShowableTests {

    @Test("showAlert presents a UIAlertController on self with title and message")
    func showAlertCarriesTextFields() throws {
        let host = CapturingHost()
        let config = TestAlertConfig(
            style: .alert,
            title: "Confirm",
            message: "Are you sure?",
            actions: []
        )
        host.showAlert(with: config)
        let alert = try #require(host.captured as? UIAlertController)
        #expect(alert.title == "Confirm")
        #expect(alert.message == "Are you sure?")
        #expect(alert.preferredStyle == .alert)
    }

    @Test("showAlert attaches all actions in declaration order")
    func showAlertAttachesActions() throws {
        let host = CapturingHost()
        let actions = [
            UIAlertAction(title: "OK", style: .default),
            UIAlertAction(title: "Cancel", style: .cancel),
            UIAlertAction(title: "Delete", style: .destructive)
        ]
        let config = TestAlertConfig(
            style: .alert,
            title: nil,
            message: nil,
            actions: actions
        )
        host.showAlert(with: config)
        let alert = try #require(host.captured as? UIAlertController)
        #expect(alert.actions.count == 3)
        #expect(alert.actions[0].title == "OK")
        #expect(alert.actions[1].title == "Cancel")
        #expect(alert.actions[2].title == "Delete")
        #expect(alert.actions[1].style == .cancel)
        #expect(alert.actions[2].style == .destructive)
    }

    @Test("showAlert respects actionSheet style")
    func showAlertActionSheetStyle() throws {
        let host = CapturingHost()
        let config = TestAlertConfig(
            style: .actionSheet,
            title: nil,
            message: nil,
            actions: []
        )
        host.showAlert(with: config)
        let alert = try #require(host.captured as? UIAlertController)
        #expect(alert.preferredStyle == .actionSheet)
    }
}
