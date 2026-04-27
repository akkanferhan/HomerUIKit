import Testing
import UIKit
@testable import HomerUIKit

private struct TestAlertConfig: AlertConfigurable {
    let style: UIAlertController.Style
    let title: String?
    let message: String?
    let actions: [UIAlertAction]
}

@MainActor
private final class CapturingPresenter {

    struct Captured {
        let alert: UIAlertController
        let dismiss: @MainActor () -> Void
    }

    private(set) var captured: [Captured] = []

    func makeOverride() -> (UIAlertController, @escaping @MainActor () -> Void) -> Void {
        { [weak self] alert, dismiss in
            self?.captured.append(Captured(alert: alert, dismiss: dismiss))
        }
    }

    func dismissTopmost() {
        guard let top = captured.last else { return }
        top.dismiss()
    }

    func dismissFirst() {
        guard let first = captured.first else { return }
        first.dismiss()
    }
}

@Suite("AlertManager")
@MainActor
struct AlertManagerTests {

    @Test("enqueue presents the configuration immediately when idle")
    func enqueueShowsImmediatelyWhenIdle() throws {
        let manager = AlertManager()
        let presenter = CapturingPresenter()
        manager.presentationOverride = presenter.makeOverride()

        manager.enqueue(TestAlertConfig(
            style: .alert,
            title: "First",
            message: nil,
            actions: []
        ))

        #expect(presenter.captured.count == 1)
        #expect(presenter.captured[0].alert.title == "First")
        #expect(manager.isShowingAlert)
    }

    @Test("two concurrent enqueues only present the first; second waits for dismissal")
    func twoEnqueuesDeferSecondUntilDismissal() throws {
        let manager = AlertManager()
        let presenter = CapturingPresenter()
        manager.presentationOverride = presenter.makeOverride()

        manager.enqueue(TestAlertConfig(
            style: .alert, title: "First", message: nil, actions: []
        ))
        manager.enqueue(TestAlertConfig(
            style: .alert, title: "Second", message: nil, actions: []
        ))

        #expect(presenter.captured.count == 1)
        #expect(presenter.captured[0].alert.title == "First")
        #expect(manager.pendingCount == 1)

        presenter.dismissFirst()

        #expect(presenter.captured.count == 2)
        #expect(presenter.captured[1].alert.title == "Second")
        #expect(manager.pendingCount == 0)
    }

    @Test("enqueue preserves FIFO order across many requests")
    func fifoOrderPreserved() throws {
        let manager = AlertManager()
        let presenter = CapturingPresenter()
        manager.presentationOverride = presenter.makeOverride()

        for i in 1...4 {
            manager.enqueue(TestAlertConfig(
                style: .alert, title: "#\(i)", message: nil, actions: []
            ))
        }

        #expect(presenter.captured.count == 1)
        #expect(presenter.captured[0].alert.title == "#1")

        presenter.dismissTopmost()
        #expect(presenter.captured.last?.alert.title == "#2")

        presenter.dismissTopmost()
        #expect(presenter.captured.last?.alert.title == "#3")

        presenter.dismissTopmost()
        #expect(presenter.captured.last?.alert.title == "#4")

        #expect(manager.pendingCount == 0)
        #expect(manager.isShowingAlert)
    }

    @Test("manager returns to idle after the last alert dismisses")
    func returnsToIdleAfterLastDismissal() throws {
        let manager = AlertManager()
        let presenter = CapturingPresenter()
        manager.presentationOverride = presenter.makeOverride()

        manager.enqueue(TestAlertConfig(
            style: .alert, title: "Only", message: nil, actions: []
        ))
        presenter.dismissTopmost()

        #expect(!manager.isShowingAlert)
        #expect(manager.pendingCount == 0)
    }

    @Test("alert preserves configuration title, message, style, and actions")
    func configurationCarriedThroughToAlert() throws {
        let manager = AlertManager()
        let presenter = CapturingPresenter()
        manager.presentationOverride = presenter.makeOverride()

        let actions = [
            UIAlertAction(title: "Cancel", style: .cancel),
            UIAlertAction(title: "Delete", style: .destructive)
        ]
        manager.enqueue(TestAlertConfig(
            style: .actionSheet,
            title: "Confirm",
            message: "Are you sure?",
            actions: actions
        ))

        let alert = try #require(presenter.captured.first?.alert)
        #expect(alert.title == "Confirm")
        #expect(alert.message == "Are you sure?")
        #expect(alert.preferredStyle == .actionSheet)
        #expect(alert.actions.count == 2)
        #expect(alert.actions[0].title == "Cancel")
        #expect(alert.actions[0].style == .cancel)
        #expect(alert.actions[1].title == "Delete")
        #expect(alert.actions[1].style == .destructive)
    }

    @Test("an enqueue that arrives while presenting waits, then runs after dismissal")
    func midPresentationEnqueueWaits() throws {
        let manager = AlertManager()
        let presenter = CapturingPresenter()
        manager.presentationOverride = presenter.makeOverride()

        manager.enqueue(TestAlertConfig(
            style: .alert, title: "First", message: nil, actions: []
        ))
        #expect(presenter.captured.count == 1)

        manager.enqueue(TestAlertConfig(
            style: .alert, title: "Late", message: nil, actions: []
        ))
        #expect(presenter.captured.count == 1, "Late enqueue must not pre-empt the active alert")

        presenter.dismissFirst()
        #expect(presenter.captured.count == 2)
        #expect(presenter.captured[1].alert.title == "Late")
    }
}
