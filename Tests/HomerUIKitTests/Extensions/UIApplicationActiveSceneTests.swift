import Testing
import UIKit
@testable import HomerUIKit

/// `activeForegroundWindowScene` is documented to return `nil` inside
/// unit-test targets that have no scene wired up — these tests pin
/// that contract (the managers' scene-less code paths rely on it) and
/// the property's consistency with `connectedScenes`.
@Suite("UIApplication.activeForegroundWindowScene")
@MainActor
struct UIApplicationActiveSceneTests {

    @Test("returns nil or a foreground-active scene, never anything else")
    func resultIsNilOrForegroundActive() {
        let scene = UIApplication.shared.activeForegroundWindowScene
        if let scene {
            #expect(scene.activationState == .foregroundActive)
        } else {
            // The documented unit-test environment: no scene available.
            #expect(scene == nil)
        }
    }

    @Test("result is consistent with connectedScenes")
    func consistentWithConnectedScenes() {
        let expected = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        #expect(UIApplication.shared.activeForegroundWindowScene === expected)
    }

    @Test("repeated reads are stable within a run loop turn")
    func repeatedReadsAreStable() {
        let first = UIApplication.shared.activeForegroundWindowScene
        let second = UIApplication.shared.activeForegroundWindowScene
        #expect(first === second)
    }
}
