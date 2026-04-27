import Testing
import UIKit
@testable import HomerUIKit

private struct TestAlertConfig: AlertConfigurable {
    let style: UIAlertController.Style
    let title: String?
    let message: String?
    let actions: [UIAlertAction]
}

/// Unit tests for ``AlertManager`` are intentionally minimal: the
/// queue-sequencing logic is gated behind a real `UIWindowScene`,
/// which unit-test targets do not have. Exercising the FIFO ordering
/// and dismissal pump end-to-end requires an integration test with a
/// hosted scene (XCUITest or a host-app SPM target). The smoke tests
/// below verify only that the public surface compiles, conforms to
/// the protocol contract, and tolerates being called without a scene.
@Suite("AlertManager")
@MainActor
struct AlertManagerTests {

    @Test("AlertManager conforms to AlertManagerProtocol")
    func conformsToProtocol() {
        let manager: any AlertManagerProtocol = AlertManager()
        _ = manager
    }

    @Test("enqueue does not crash without a foreground-active scene")
    func enqueueWithoutSceneDoesNotCrash() {
        let manager = AlertManager()
        manager.enqueue(TestAlertConfig(
            style: .alert,
            title: "Test",
            message: nil,
            actions: []
        ))
    }

    @Test("removeAll does not crash on an empty queue")
    func removeAllOnEmptyQueueDoesNotCrash() {
        let manager = AlertManager()
        manager.removeAll()
    }

    @Test("removeAll does not crash after enqueueing")
    func removeAllAfterEnqueueDoesNotCrash() {
        let manager = AlertManager()
        manager.enqueue(TestAlertConfig(
            style: .alert, title: "A", message: nil, actions: []
        ))
        manager.enqueue(TestAlertConfig(
            style: .alert, title: "B", message: nil, actions: []
        ))
        manager.removeAll()
    }
}
