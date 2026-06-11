import Testing
import UIKit
@testable import HomerUIKit

private struct TestLoadingConfig: LoadingConfigurable {
    let loadingIndicatorHasBackground: Bool
}

/// Unit tests for ``LoadingManager`` are intentionally minimal: the
/// presentation logic is gated behind a real `UIWindowScene`, which
/// unit-test targets do not have. Exercising the visible/hidden
/// transition end-to-end requires an integration test with a hosted
/// scene (XCUITest or a host-app SPM target). The smoke tests below
/// verify only that the public surface compiles, conforms to the
/// protocol contract, and tolerates being driven without a scene.
@Suite("LoadingManager")
@MainActor
struct LoadingManagerTests {

    @Test("LoadingManager conforms to LoadingManagerProtocol")
    func conformsToProtocol() {
        let manager: any LoadingManagerProtocol = LoadingManager()
        _ = manager
    }

    @Test("show does not crash without a foreground-active scene")
    func showWithoutSceneDoesNotCrash() {
        let manager = LoadingManager()
        manager.show()
    }

    @Test("hide does not crash on a fresh manager")
    func hideOnFreshManagerDoesNotCrash() {
        let manager = LoadingManager()
        manager.hide()
    }

    @Test("hide clamps the counter at zero across extra calls")
    func hideClampsAtZero() {
        let manager = LoadingManager()
        manager.hide()
        manager.hide()
        manager.hide()
    }

    @Test("forceHide does not crash on a fresh manager")
    func forceHideOnFreshManagerDoesNotCrash() {
        let manager = LoadingManager()
        manager.forceHide()
    }

    @Test("forceHide does not crash after several show calls")
    func forceHideAfterShowsDoesNotCrash() {
        let manager = LoadingManager()
        manager.show()
        manager.show()
        manager.show()
        manager.forceHide()
    }

    @Test("configure does not crash and accepts a configuration value")
    func configureDoesNotCrash() {
        let manager = LoadingManager()
        manager.configure(with: TestLoadingConfig(loadingIndicatorHasBackground: false))
        manager.configure(with: TestLoadingConfig(loadingIndicatorHasBackground: true))
    }

    @Test("show without a scene preserves the reference count")
    func showWithoutScenePreservesCount() {
        let manager = LoadingManager()
        manager.show()
        #expect(manager.activeLoadingCount == 1,
                "A scene-less show() must keep the balance so hide() pairing stays intact")
        manager.show()
        #expect(manager.activeLoadingCount == 2)
    }

    @Test("show/hide pairing balances back to zero without a scene")
    func showHidePairingBalancesWithoutScene() {
        let manager = LoadingManager()
        manager.show()
        manager.show()
        manager.hide()
        #expect(manager.activeLoadingCount == 1)
        manager.hide()
        #expect(manager.activeLoadingCount == 0)
    }

    @Test("forceHide zeroes a scene-less accumulated count")
    func forceHideZeroesAccumulatedCount() {
        let manager = LoadingManager()
        manager.show()
        manager.show()
        manager.forceHide()
        #expect(manager.activeLoadingCount == 0)
    }
}
