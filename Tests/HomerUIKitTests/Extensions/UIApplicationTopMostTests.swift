import Testing
import UIKit
@testable import HomerUIKit

@MainActor
private final class StubPresentingVC: UIViewController {
    var stubPresented: UIViewController?
    override var presentedViewController: UIViewController? { stubPresented }
}

@Suite("UIApplication.topMost(from:)")
@MainActor
struct UIApplicationTopMostTests {

    @Test("returns the receiver when no presentation, no nav, no tab")
    func plainViewController() {
        let plain = UIViewController()
        #expect(UIApplication.topMost(from: plain) === plain)
    }

    @Test("unwraps a UINavigationController to its visible view controller")
    func unwrapsNavigation() {
        let leaf = UIViewController()
        let nav = UINavigationController(rootViewController: leaf)
        #expect(UIApplication.topMost(from: nav) === leaf)
    }

    @Test("unwraps a UITabBarController to its selected view controller")
    func unwrapsTabBar() {
        let first = UIViewController()
        let second = UIViewController()
        let tab = UITabBarController()
        tab.viewControllers = [first, second]
        tab.selectedIndex = 1
        #expect(UIApplication.topMost(from: tab) === second)
    }

    @Test("unwraps nested tab → nav → leaf chain")
    func unwrapsNestedChain() {
        let leaf = UIViewController()
        let nav = UINavigationController(rootViewController: leaf)
        let tab = UITabBarController()
        tab.viewControllers = [nav]
        #expect(UIApplication.topMost(from: tab) === leaf)
    }

    @Test("unwraps a presented view controller")
    func unwrapsPresentation() {
        let presented = UIViewController()
        let presenting = StubPresentingVC()
        presenting.stubPresented = presented
        #expect(UIApplication.topMost(from: presenting) === presented)
    }

    @Test("presentation takes precedence over container unwrapping")
    func presentationBeatsContainer() {
        let presentedLeaf = UIViewController()
        let presentingNavRoot = StubPresentingVC()
        presentingNavRoot.stubPresented = presentedLeaf
        let nav = UINavigationController(rootViewController: presentingNavRoot)
        // Nav unwraps to presentingNavRoot, which then unwraps to its presented.
        #expect(UIApplication.topMost(from: nav) === presentedLeaf)
    }
}
