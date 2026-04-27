//
//  LoadingManager.swift
//  HomerUIKit
//
//  Created by Ferhan on 27.04.2026.
//

import UIKit

/// Drives a global loading indicator hosted in a dedicated window
/// above the application's content.
///
/// `LoadingManager` is a `@MainActor` reference-counted controller:
/// every ``show()`` call increments a counter, and the indicator
/// stays visible until the matching ``hide()`` calls bring the
/// counter back to zero. This lets independent call sites surface
/// loading state concurrently without stepping on each other —
/// e.g. one screen kicks off a refresh while another submits a form,
/// and the indicator only disappears once both finish.
///
/// The indicator is presented in a private `UIWindow` at
/// ``UIKit/UIWindow/Level/alert`` `- 1`, one notch below
/// ``AlertManager``'s window so alerts can layer on top of the
/// loading dim. The window is created lazily on first ``show()``
/// and torn down once the counter returns to zero, so an idle
/// `LoadingManager` holds no UIKit resources.
///
/// ## Thread safety
///
/// The class is `@MainActor`-isolated. All state mutations and
/// UIKit calls run on the main actor's serial executor; concurrent
/// callers from background contexts hop to the main actor before
/// touching shared state.
///
/// ## Lifecycle
///
/// Inject a single `LoadingManager` instance via your composition
/// root and depend on ``LoadingManagerProtocol`` at consumer sites
/// so unit tests can substitute a mock — there is no shared
/// singleton on the type.
@MainActor
public final class LoadingManager: LoadingManagerProtocol {

    private var loadingCount: Int = .zero
    private var loadingWindow: UIWindow?
    private var indicatorHasBackground: Bool = true

    public init() {}

    public func configure(with configuration: any LoadingConfigurable) {
        indicatorHasBackground = configuration.loadingIndicatorHasBackground
    }

    public func show() {
        loadingCount += 1
        guard loadingCount == 1 else { return }
        presentIndicator()
    }

    public func hide() {
        guard loadingCount > 0 else { return }
        loadingCount -= 1
        guard loadingCount == 0 else { return }
        tearDownWindow()
    }

    public func forceHide() {
        loadingCount = 0
        tearDownWindow()
    }
}

private extension LoadingManager {

    func presentIndicator() {
        guard let scene = UIApplication.shared.activeForegroundWindowScene else {
            loadingCount = 0
            return
        }
        _ = obtainWindow(in: scene)
    }

    func obtainWindow(in scene: UIWindowScene) -> UIWindow {
        if let existing = loadingWindow, existing.windowScene === scene {
            existing.isHidden = false
            return existing
        }
        let host = LoadingHostViewController(indicatorHasBackground: indicatorHasBackground)
        let window = UIWindow(windowScene: scene)
        window.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue - 1)
        window.backgroundColor = .clear
        window.rootViewController = host
        loadingWindow = window
        window.isHidden = false
        return window
    }

    func tearDownWindow() {
        loadingWindow?.isHidden = true
        loadingWindow = nil
    }
}

@MainActor
private final class LoadingHostViewController: UIViewController {

    private let indicatorHasBackground: Bool

    private let cardView: UIView = {
        let view = UIView()
        view.cornerRadius(.medium)
        return view
    }()

    private let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()

    init(indicatorHasBackground: Bool) {
        self.indicatorHasBackground = indicatorHasBackground
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(Constants.coderInitNotImplemented)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.backgroundColor = .black.withAlphaComponent(Constants.dimAlpha)
        cardView.backgroundColor = indicatorHasBackground
            ? .black.withAlphaComponent(Constants.cardAlpha)
            : .clear

        view.addSubview(cardView)
        cardView
            .setSize(width: Constants.cardSize, height: Constants.cardSize)
            .centerInSuperview()

        cardView.addSubview(spinner)
        spinner.centerInSuperview()
        spinner.startAnimating()
    }
}

private extension LoadingHostViewController {

    enum Constants {
        static let dimAlpha: CGFloat = 0.5
        static let cardAlpha: CGFloat = 0.4
        static let cardSize: CGFloat = 100
        static let coderInitNotImplemented = "init(coder:) has not been implemented"
    }
}
