import Testing
import UIKit
@testable import HomerUIKit

@Suite("NSLayoutConstraint+Priority")
@MainActor
struct NSLayoutConstraintPriorityTests {

    @Test("withPriority assigns the supplied priority")
    func assignsPriority() {
        let view = ViewFixture.standalone()
        let constraint = view.widthAnchor.constraint(equalToConstant: 100)
        _ = constraint.withPriority(.defaultLow)
        #expect(constraint.priority == .defaultLow)
    }

    @Test("withPriority returns self for chaining")
    func returnsSelf() {
        let view = ViewFixture.standalone()
        let constraint = view.widthAnchor.constraint(equalToConstant: 100)
        let returned = constraint.withPriority(.defaultHigh)
        #expect(returned === constraint)
    }

    @Test("withPriority can be chained ahead of activation")
    func chainsBeforeActivation() {
        let view = ViewFixture.standalone()
        let constraint = view.widthAnchor
            .constraint(equalToConstant: 200)
            .withPriority(UILayoutPriority(750))
        constraint.isActive = true
        #expect(constraint.priority.rawValue == 750)
        #expect(constraint.isActive)
    }
}
