import HomerFoundation
import UIKit

/// Serialises ``AlertConfigurable`` presentations through a dedicated
/// alert window, ensuring at most one alert is on screen at any time
/// regardless of how many concurrent call sites enqueue alerts.
///
/// `AlertManager` solves two recurring problems with ad-hoc
/// `UIViewController.present(_:animated:)` calls for alerts:
///
/// 1. **Concurrent requests are dropped.** UIKit logs a warning and
///    silently ignores `present` when the host already has a presented
///    view controller. Routing every alert through this manager queues
///    requests and shows them in turn — second and third callers no
///    longer race the first.
///
/// 2. **Presentation hierarchy ownership.** The manager creates its
///    own `UIWindow` at ``UIKit/UIWindow/Level/alert`` `+ 1` and
///    presents the alert on a private host view controller. Alert
///    lifetime is decoupled from any specific scene's view-controller
///    stack — pop, push, or full-screen modal transitions in the
///    underlying app no longer race with alert presentation, and the
///    alert is never accidentally dismissed when the host VC is
///    deallocated.
///
/// ## Thread safety
///
/// The class is `@MainActor`-isolated. All state mutations and UIKit
/// calls run on the main actor's serial executor, so concurrent
/// callers from any number of background contexts can enqueue safely
/// — they hop to the main actor before touching shared state.
/// ```
@MainActor
public final class AlertManager: AlertManagerProtocol {

    private var queue: [any AlertConfigurable] = []
    private var isPresenting = false
    private var alertWindow: UIWindow?

    public init() {}

    public func enqueue(_ configuration: any AlertConfigurable) {
        queue.append(configuration)
        presentNextIfNeeded()
    }

    public func removeAll() {
        queue.removeAll()
        alertWindow?.rootViewController?.presentedViewController?.dismiss(animated: true)
    }
}

private extension AlertManager {

    func presentNextIfNeeded() {
        guard !isPresenting else { return }
        guard !queue.isEmpty else {
            tearDownWindow()
            return
        }
        let next = queue.removeFirst()
        isPresenting = true
        present(next)
    }

    func present(_ configuration: any AlertConfigurable) {
        guard let scene = UIApplication.shared.activeForegroundWindowScene else {
            isPresenting = false
            return
        }
        let window = obtainWindow(in: scene)
        guard let host = window.rootViewController else {
            isPresenting = false
            return
        }

        let alert = TrackedAlertController(
            title: configuration.title,
            message: configuration.message,
            preferredStyle: configuration.style
        )
        for action in configuration.actions {
            alert.addAction(action)
        }
        alert.onDismiss = { [weak self] in
            self?.handleDismissal()
        }
        configurePopover(alert: alert, host: host)
        host.present(alert, animated: true)
    }

    func handleDismissal() {
        isPresenting = false
        presentNextIfNeeded()
    }

    func obtainWindow(in scene: UIWindowScene) -> UIWindow {
        if let existing = alertWindow, existing.windowScene === scene {
            return existing
        }
        let window = UIWindow(windowScene: scene)
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue + 1)
        window.backgroundColor = .clear
        window.rootViewController = AlertHostViewController()
        alertWindow = window
        window.isHidden = false
        return window
    }

    func tearDownWindow() {
        alertWindow?.isHidden = true
        alertWindow = nil
    }

    func configurePopover(alert: UIAlertController, host: UIViewController) {
        guard let popover = alert.popoverPresentationController else { return }
        let view = host.view!
        popover.sourceView = view
        popover.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.midY,
            width: .zero,
            height: .zero
        )
        popover.permittedArrowDirections = []
    }
}

@MainActor
private final class TrackedAlertController: UIAlertController {

    var onDismiss: VoidCompletion?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let callback = onDismiss
        onDismiss = nil
        callback?()
    }
}

@MainActor
private final class AlertHostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
