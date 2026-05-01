import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIViewController+ChildContainment extension")
struct UIViewControllerChildContainmentTests {

    // MARK: attachChild — default container

    @Test("attachChild adds child to childViewControllers")
    func attachAddsChild() {
        let parent = UIViewController()
        let child = UIViewController()
        parent.attachChild(child)
        #expect(parent.children.contains(child))
        #expect(child.parent === parent)
    }

    @Test("attachChild adds child.view to parent.view by default")
    func attachAddsViewToParentView() {
        let parent = UIViewController()
        let child = UIViewController()
        parent.attachChild(child)
        #expect(child.view.superview === parent.view)
    }

    @Test("attachChild pins the child view with four edge constraints")
    func attachPinsFourEdges() {
        let parent = UIViewController()
        parent.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        let child = UIViewController()
        parent.attachChild(child)
        #expect(parent.view.constraints.count == 4)
    }

    // MARK: attachChild — custom container

    @Test("attachChild attaches to the supplied container view when provided")
    func attachUsesCustomContainer() {
        let parent = UIViewController()
        parent.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        let container = UIView(frame: parent.view.bounds)
        parent.view.addSubview(container)
        let child = UIViewController()
        parent.attachChild(child, in: container)
        #expect(child.view.superview === container)
        #expect(parent.children.contains(child))
    }

    // MARK: attachChild — insets

    @Test("attachChild forwards insets to pinToSuperview")
    func attachForwardsInsets() {
        let parent = UIViewController()
        parent.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        let child = UIViewController()
        parent.attachChild(child, insets: UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4))
        let constants = Set(parent.view.constraints.map(\.constant))
        #expect(constants.contains(1))
        #expect(constants.contains(2))
        #expect(constants.contains(-3))
        #expect(constants.contains(-4))
    }

    // MARK: detachFromParent

    @Test("detachFromParent removes child from parent and from view hierarchy")
    func detachRemovesChild() {
        let parent = UIViewController()
        parent.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        let child = UIViewController()
        parent.attachChild(child)
        child.detachFromParent()
        #expect(parent.children.isEmpty)
        #expect(child.parent == nil)
        #expect(child.view.superview == nil)
    }

    @Test("detachFromParent on an unparented controller is a no-op")
    func detachOnUnparentedNoCrash() {
        let orphan = UIViewController()
        orphan.detachFromParent()
        #expect(orphan.parent == nil)
    }
}
