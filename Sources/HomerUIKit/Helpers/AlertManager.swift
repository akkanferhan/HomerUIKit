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
///
/// ```swift
/// // From any actor:
/// Task { @MainActor in
///     AlertManager.shared.enqueue(MyAlertConfig())
/// }
/// ```
@MainActor
public final class AlertManager {

    /// Shared singleton. Use this from app code; reserve dedicated
    /// instances for tests.
    public static let shared = AlertManager()

    private var queue: [any AlertConfigurable] = []
    private var isPresenting = false
    private var alertWindow: UIWindow?

    /// Test seam: when set, this closure is called instead of
    /// presenting the alert in the dedicated window. The closure
    /// receives the configured alert controller and a dismissal
    /// completion that the test invokes to simulate the user
    /// dismissing the alert.
    var presentationOverride: ((UIAlertController, @escaping @MainActor () -> Void) -> Void)?

    /// Creates a new manager. Prefer ``shared`` from app code.
    public init() {}

    /// Adds a configuration to the FIFO queue. If no alert is
    /// presenting, the new alert is shown immediately; otherwise it
    /// waits its turn behind any earlier enqueues.
    ///
    /// - Parameter configuration: The alert description to present.
    public func enqueue(_ configuration: any AlertConfigurable) {
        queue.append(configuration)
        presentNextIfNeeded()
    }

    /// Number of queued alerts not yet shown. Exposed for tests and
    /// diagnostics.
    var pendingCount: Int { queue.count }

    /// Whether an alert is currently on screen. Exposed for tests.
    var isShowingAlert: Bool { isPresenting }

    private func presentNextIfNeeded() {
        guard !isPresenting else { return }
        guard !queue.isEmpty else {
            tearDownWindowIfNeeded()
            return
        }
        let next = queue.removeFirst()
        isPresenting = true
        present(next)
    }

    private func present(_ configuration: any AlertConfigurable) {
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

        if let presentationOverride {
            presentationOverride(alert) { [weak self] in
                self?.handleDismissal()
            }
            return
        }

        guard let scene = activeForegroundWindowScene() else {
            isPresenting = false
            return
        }
        let window = obtainWindow(in: scene)
        guard let host = window.rootViewController else {
            isPresenting = false
            return
        }
        configurePopover(alert: alert, host: host)
        host.present(alert, animated: true)
    }

    private func handleDismissal() {
        isPresenting = false
        presentNextIfNeeded()
    }

    private func obtainWindow(in scene: UIWindowScene) -> UIWindow {
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

    private func tearDownWindowIfNeeded() {
        alertWindow?.isHidden = true
        alertWindow = nil
    }

    private func activeForegroundWindowScene() -> UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }

    private func configurePopover(alert: UIAlertController, host: UIViewController) {
        guard let popover = alert.popoverPresentationController else { return }
        let view = host.view!
        popover.sourceView = view
        popover.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.midY,
            width: 0,
            height: 0
        )
        popover.permittedArrowDirections = []
    }
}

@MainActor
private final class TrackedAlertController: UIAlertController {

    var onDismiss: (() -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let callback = onDismiss
        onDismiss = nil
        callback?()
    }
}

@MainActor
private final class AlertHostViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .all
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}
