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

    // MARK: anchor(...)

    @Test("anchor activates one constraint per supplied edge")
    func anchorActivatesPerEdge() {
        let (child, container) = ViewFixture.parented()
        let constraints = child.anchor(
            top: container.topAnchor,
            leading: container.leadingAnchor,
            bottom: container.bottomAnchor,
            trailing: container.trailingAnchor
        )
        #expect(constraints.count == 4)
        #expect(constraints.allSatisfy { $0.isActive })
    }

    @Test("anchor skips edges left as nil")
    func anchorSkipsNilEdges() {
        let (child, container) = ViewFixture.parented()
        let constraints = child.anchor(
            top: container.topAnchor,
            leading: container.leadingAnchor
        )
        #expect(constraints.count == 2)
    }

    @Test("anchor negates bottom and trailing padding so positive values move inwards")
    func anchorNegatesBottomTrailingPadding() throws {
        let (child, container) = ViewFixture.parented()
        let constraints = child.anchor(
            top: container.topAnchor,
            leading: container.leadingAnchor,
            bottom: container.bottomAnchor,
            trailing: container.trailingAnchor,
            padding: UIEdgeInsets(top: 4, left: 8, bottom: 12, right: 16)
        )
        #expect(constraints[0].constant == 4)    // top
        #expect(constraints[1].constant == 8)    // leading
        #expect(constraints[2].constant == -12)  // bottom (negated)
        #expect(constraints[3].constant == -16)  // trailing (negated)
    }

    @Test("anchor adds width and height constants when size is non-zero")
    func anchorIncludesSizeConstraints() {
        let (child, container) = ViewFixture.parented()
        let constraints = child.anchor(
            top: container.topAnchor,
            size: CGSize(width: 100, height: 50)
        )
        #expect(constraints.count == 3)  // top + width + height
        let widthConstant = constraints.first { $0.firstAttribute == .width }?.constant
        let heightConstant = constraints.first { $0.firstAttribute == .height }?.constant
        #expect(widthConstant == 100)
        #expect(heightConstant == 50)
    }

    @Test("anchor disables autoresizing translation")
    func anchorDisablesTAMIC() {
        let (child, container) = ViewFixture.parented()
        child.translatesAutoresizingMaskIntoConstraints = true
        _ = child.anchor(top: container.topAnchor)
        #expect(child.translatesAutoresizingMaskIntoConstraints == false)
    }

    // MARK: centerInSuperview(size:)

    @Test("centerInSuperview(size:) installs centre + width + height constraints")
    func centerInSuperviewWithSize() {
        let (child, container) = ViewFixture.parented()
        child.centerInSuperview(size: CGSize(width: 80, height: 40))
        // Centre constraints land on the container; width/height land on the child itself.
        let centreCount = container.constraints.filter {
            $0.firstAttribute == .centerX || $0.firstAttribute == .centerY
        }.count
        let widthCount = child.constraints.filter { $0.firstAttribute == .width }.count
        let heightCount = child.constraints.filter { $0.firstAttribute == .height }.count
        #expect(centreCount == 2)
        #expect(widthCount == 1)
        #expect(heightCount == 1)
    }

    @Test("centerInSuperview(size:) skips zero or negative components")
    func centerInSuperviewSkipsZeroSize() {
        let (child, container) = ViewFixture.parented()
        child.centerInSuperview(size: .zero)
        _ = container
        let widthCount = child.constraints.filter { $0.firstAttribute == .width }.count
        let heightCount = child.constraints.filter { $0.firstAttribute == .height }.count
        #expect(widthCount == 0)
        #expect(heightCount == 0)
    }

    // MARK: centerX / centerY

    @Test("centerX(inView:) installs a centerX constraint and returns self")
    func centerXInstallsConstraint() {
        let (child, container) = ViewFixture.parented()
        let returned = child.centerX(inView: container)
        let centreX = container.constraints.first { $0.firstAttribute == .centerX }
        #expect(centreX != nil)
        #expect(centreX?.isActive == true)
        #expect(returned === child)
    }

    @Test("centerX(inView:topAnchor:paddingTop:) pins the top with the supplied padding")
    func centerXWithTopAnchor() throws {
        let (child, container) = ViewFixture.parented()
        child.centerX(inView: container, topAnchor: container.topAnchor, paddingTop: 24)
        let topConstraint = try #require(container.constraints.first {
            $0.firstAttribute == .top && $0.firstItem === child
        })
        #expect(topConstraint.constant == 24)
    }

    @Test("centerY(inView:) installs a centerY constraint and returns self")
    func centerYInstallsConstraint() {
        let (child, container) = ViewFixture.parented()
        let returned = child.centerY(inView: container)
        let centreY = container.constraints.first { $0.firstAttribute == .centerY }
        #expect(centreY != nil)
        #expect(centreY?.isActive == true)
        #expect(returned === child)
    }

    @Test("centerY(inView:leadingAnchor:paddingLeading:) pins leading with the supplied padding")
    func centerYWithLeadingAnchor() throws {
        let (child, container) = ViewFixture.parented()
        child.centerY(inView: container, leadingAnchor: container.leadingAnchor, paddingLeading: 12)
        let leadingConstraint = try #require(container.constraints.first {
            $0.firstAttribute == .leading && $0.firstItem === child
        })
        #expect(leadingConstraint.constant == 12)
    }
}
