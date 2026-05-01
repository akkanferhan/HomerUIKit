import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIControl+Action extension")
struct UIControlActionTests {

    @Test("addAction registers the event with allControlEvents")
    func addActionRegistersForEvent() {
        let control = UIControl()
        control.addAction(for: .valueChanged) { _ in }
        #expect(control.allControlEvents.contains(.valueChanged))
    }

    @Test("addAction handler fires when the matching event is sent")
    func handlerFiresOnEvent() {
        let control = UIControl()
        var fired = 0
        control.addAction(for: .valueChanged) { _ in
            fired += 1
        }
        control.sendActions(for: .valueChanged)
        #expect(fired == 1)
    }

    @Test("addAction handler does not fire for unrelated events")
    func handlerIgnoresOtherEvents() {
        let control = UIControl()
        var fired = 0
        control.addAction(for: .touchUpInside) { _ in
            fired += 1
        }
        control.sendActions(for: .valueChanged)
        #expect(fired == 0)
    }

    @Test("returned UIAction can be removed via removeAction(_:for:)")
    func returnedActionRemovable() {
        let control = UIControl()
        var fired = 0
        let action = control.addAction(for: .valueChanged) { _ in
            fired += 1
        }
        control.removeAction(action, for: .valueChanged)
        control.sendActions(for: .valueChanged)
        #expect(fired == 0)
    }
}
