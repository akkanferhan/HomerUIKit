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

    // MARK: setWidth(equalTo:)

    @Test("setWidth(equalTo:) installs an equal-width constraint between two views")
    func setWidthEqualToInstallsConstraint() throws {
        let (child, container) = ViewFixture.parented()
        let sibling = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        container.addSubview(sibling)
        child.setWidth(equalTo: sibling)
        let constraint = try #require(container.constraints.first {
            $0.firstAttribute == .width && $0.relation == .equal && $0.secondAttribute == .width
        })
        #expect(constraint.isActive)
        #expect(constraint.firstItem === child)
        #expect(constraint.secondItem === sibling)
    }

    @Test("setWidth(equalTo:) returns self for chaining")
    func setWidthEqualToIsChainable() {
        let (child, container) = ViewFixture.parented()
        let sibling = UIView()
        container.addSubview(sibling)
        let returned = child.setWidth(equalTo: sibling)
        #expect(returned === child)
    }

    // MARK: setHeight(equalTo:)

    @Test("setHeight(equalTo:) installs an equal-height constraint between two views")
    func setHeightEqualToInstallsConstraint() throws {
        let (child, container) = ViewFixture.parented()
        let sibling = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        container.addSubview(sibling)
        child.setHeight(equalTo: sibling)
        let constraint = try #require(container.constraints.first {
            $0.firstAttribute == .height && $0.relation == .equal && $0.secondAttribute == .height
        })
        #expect(constraint.isActive)
        #expect(constraint.firstItem === child)
        #expect(constraint.secondItem === sibling)
    }

    @Test("setHeight(equalTo:) disables autoresizing translation")
    func setHeightEqualToDisablesTAMIC() {
        let (child, container) = ViewFixture.parented()
        let sibling = UIView()
        container.addSubview(sibling)
        child.translatesAutoresizingMaskIntoConstraints = true
        child.setHeight(equalTo: sibling)
        #expect(child.translatesAutoresizingMaskIntoConstraints == false)
    }

    @Test("setHeight(equalTo:) returns self for chaining")
    func setHeightEqualToIsChainable() {
        let (child, container) = ViewFixture.parented()
        let sibling = UIView()
        container.addSubview(sibling)
        let returned = child.setHeight(equalTo: sibling)
        #expect(returned === child)
    }

    // MARK: setAspectRatio

    @Test("setAspectRatio installs a width-to-height multiplier constraint")
    func setAspectRatioInstallsConstraint() {
        let view = ViewFixture.standalone()
        let constraint = view.setAspectRatio(2.0)
        #expect(constraint.isActive)
        #expect(constraint.firstAttribute == .width)
        #expect(constraint.secondAttribute == .height)
        #expect(constraint.multiplier == 2.0)
    }

    @Test("setAspectRatio disables autoresizing translation")
    func setAspectRatioDisablesTAMIC() {
        let view = ViewFixture.standalone()
        view.translatesAutoresizingMaskIntoConstraints = true
        _ = view.setAspectRatio(1)
        #expect(view.translatesAutoresizingMaskIntoConstraints == false)
    }
}
