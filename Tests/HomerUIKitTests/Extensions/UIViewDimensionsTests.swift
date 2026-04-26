import Testing
import UIKit
@testable import HomerUIKit

@Suite("UIView dimensions")
@MainActor
struct UIViewDimensionsTests {

    @Test("setWidth disables autoresizing translation")
    func setWidthDisablesTAMIC() {
        let view = ViewFixture.standalone()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.setWidth(120)
        #expect(view.translatesAutoresizingMaskIntoConstraints == false)
    }

    @Test("setWidth installs an equal-constant width constraint")
    func setWidthAddsConstraint() throws {
        let view = ViewFixture.standalone()
        view.setWidth(120)
        let constraint = try #require(view.constraints.first { $0.firstAttribute == .width })
        #expect(constraint.relation == .equal)
        #expect(constraint.constant == 120)
        #expect(constraint.isActive)
    }

    @Test("setHeight installs an equal-constant height constraint")
    func setHeightAddsConstraint() throws {
        let view = ViewFixture.standalone()
        view.setHeight(60)
        let constraint = try #require(view.constraints.first { $0.firstAttribute == .height })
        #expect(constraint.relation == .equal)
        #expect(constraint.constant == 60)
    }

    @Test("setSize installs both width and height equal-constant constraints")
    func setSizeAddsBoth() {
        let view = ViewFixture.standalone()
        view.setSize(width: 80, height: 40)
        let widths = view.constraints.filter { $0.firstAttribute == .width && $0.relation == .equal }
        let heights = view.constraints.filter { $0.firstAttribute == .height && $0.relation == .equal }
        #expect(widths.count == 1)
        #expect(heights.count == 1)
        #expect(widths.first?.constant == 80)
        #expect(heights.first?.constant == 40)
    }

    @Test("setMinimumHeight installs a greaterThanOrEqual height constraint")
    func setMinimumHeightAddsConstraint() throws {
        let view = ViewFixture.standalone()
        view.setMinimumHeight(44)
        let constraint = try #require(view.constraints.first { $0.firstAttribute == .height })
        #expect(constraint.relation == .greaterThanOrEqual)
        #expect(constraint.constant == 44)
    }

    @Test("all dimension setters return self for chaining")
    func chainable() {
        let view = ViewFixture.standalone()
        let result = view
            .setWidth(10)
            .setHeight(20)
            .setSize(width: 30, height: 40)
            .setMinimumHeight(8)
        #expect(result === view)
    }
}
