import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+AutoLayout extension")
struct UIViewAutoLayoutTests {

    // MARK: pinToSuperview() — basic

    @Test("pinToSuperview sets translatesAutoresizingMaskIntoConstraints to false")
    func pinToSuperviewDisablesTAMIC() {
        let (child, container) = ViewFixture.parented()
        child.pinToSuperview()
        _ = container // retain container so child keeps its superview
        #expect(child.translatesAutoresizingMaskIntoConstraints == false)
    }

    @Test("pinToSuperview activates exactly 4 constraints on the superview")
    func pinToSuperviewActivatesFourConstraints() {
        let (child, container) = ViewFixture.parented()
        child.pinToSuperview()
        #expect(container.constraints.count == 4)
    }

    @Test("pinToSuperview with zero insets sets all constraint constants to 0")
    func pinToSuperviewZeroInsetsAllConstantsZero() {
        let (child, container) = ViewFixture.parented()
        child.pinToSuperview()
        let constants = container.constraints.map(\.constant)
        #expect(constants.allSatisfy { $0 == 0 })
    }

    // MARK: pinToSuperview(spacing:)

    @Test("pinToSuperview(spacing:.medium) insets all sides by 16")
    func pinToSuperviewSpacingMediumInsetsAllSidesByMedium() {
        let (child, container) = ViewFixture.parented()
        child.pinToSuperview(spacing: .medium)
        // Top and leading have positive constant (+16),
        // trailing and bottom have negative constant (-16).
        let positiveCount = container.constraints.filter { $0.constant == 16 }.count
        let negativeCount = container.constraints.filter { $0.constant == -16 }.count
        #expect(positiveCount == 2)
        #expect(negativeCount == 2)
    }

    // MARK: pinToSuperview with explicit UIEdgeInsets

    @Test("pinToSuperview with asymmetric insets negates right and bottom constants")
    func pinToSuperviewAsymmetricInsetsNegatesTrailingBottom() {
        let (child, container) = ViewFixture.parented()
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        child.pinToSuperview(insets: insets)
        let constants = Set(container.constraints.map(\.constant))
        // Expected constants: top=1, leading=2, trailing=-4, bottom=-3
        #expect(constants.contains(1))
        #expect(constants.contains(2))
        #expect(constants.contains(-4))
        #expect(constants.contains(-3))
    }

    // MARK: pinToSuperview() with no superview

    @Test("pinToSuperview without superview does not crash and does not mutate TAMIC")
    func pinToSuperviewNoSuperviewNoCrash() {
        let sut = ViewFixture.standalone()
        // Default value before any call
        let defaultTAMIC = sut.translatesAutoresizingMaskIntoConstraints
        sut.pinToSuperview()
        // Implementation early-returns before setting TAMIC — verify it is unchanged
        #expect(sut.translatesAutoresizingMaskIntoConstraints == defaultTAMIC)
    }

    // MARK: pinToSuperviewSafeArea()

    @Test("pinToSuperviewSafeArea activates constraints between child and safe area guide")
    func pinToSuperviewSafeAreaActivatesConstraints() {
        let (child, container) = ViewFixture.parented()
        child.pinToSuperviewSafeArea()
        // The safeAreaLayoutGuide itself installs internal constraints on the
        // container when first accessed. Filter to only those that directly
        // involve the child view to get a stable count of exactly 4.
        let childConstraints = container.constraints.filter { constraint in
            constraint.firstItem === child || constraint.secondItem === child
        }
        #expect(childConstraints.count == 4)
    }

    // MARK: centerInSuperview()

    @Test("centerInSuperview activates exactly 2 constraints on the superview")
    func centerInSuperviewActivatesTwoConstraints() {
        let (child, container) = ViewFixture.parented()
        child.centerInSuperview()
        #expect(container.constraints.count == 2)
    }

    // MARK: Chainability

    @Test("pinToSuperview returns self for chaining")
    func pinToSuperviewIsChainable() {
        let (child, container) = ViewFixture.parented()
        let returned = child.pinToSuperview()
        _ = container
        #expect(returned === child)
    }

    @Test("pinToSuperviewSafeArea returns self for chaining")
    func pinToSuperviewSafeAreaIsChainable() {
        let (child, container) = ViewFixture.parented()
        let returned = child.pinToSuperviewSafeArea()
        _ = container
        #expect(returned === child)
    }

    @Test("centerInSuperview returns self for chaining")
    func centerInSuperviewIsChainable() {
        let (child, container) = ViewFixture.parented()
        let returned = child.centerInSuperview()
        _ = container
        #expect(returned === child)
    }
}
