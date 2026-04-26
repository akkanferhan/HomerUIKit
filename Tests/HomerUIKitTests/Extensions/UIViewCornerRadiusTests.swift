import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+CornerRadius extension")
struct UIViewCornerRadiusTests {

    // MARK: Token-based corner radius

    @Test("cornerRadius(.medium) sets layer.cornerRadius to 8, clipsToBounds, and .continuous curve")
    func mediumTokenSetsExpectedValues() {
        let sut = ViewFixture.standalone()
        sut.cornerRadius(.medium)
        #expect(sut.layer.cornerRadius == 8)
        #expect(sut.clipsToBounds == true)
        #expect(sut.layer.cornerCurve == .continuous)
    }

    @Test("cornerRadius(.pill) on a 50pt-tall view sets radius to 25")
    func pillTokenOnFiftyPtTallView() {
        let sut = ViewFixture.standalone(size: CGSize(width: 100, height: 50))
        sut.cornerRadius(.pill)
        #expect(sut.layer.cornerRadius == 25)
    }

    @Test("cornerRadius(.custom(13)) sets layer.cornerRadius to 13")
    func customTokenSetsExactValue() {
        let sut = ViewFixture.standalone()
        sut.cornerRadius(.custom(13))
        #expect(sut.layer.cornerRadius == 13)
    }

    // MARK: Raw CGFloat overload

    @Test("cornerRadius(7.5) raw sets layer.cornerRadius to 7.5")
    func rawCGFloatSetsValue() {
        let sut = ViewFixture.standalone()
        sut.cornerRadius(7.5)
        #expect(sut.layer.cornerRadius == 7.5)
    }

    @Test("cornerRadius(-5) raw clamps to 0")
    func rawNegativeCGFloatClampsToZero() {
        let sut = ViewFixture.standalone()
        sut.cornerRadius(-5)
        #expect(sut.layer.cornerRadius == 0)
    }

    // MARK: Selective corners

    @Test("roundedCorners with top-edge mask sets maskedCorners and radius to 4")
    func roundedCornersTopEdgeMask() {
        let mask: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let sut = ViewFixture.standalone()
        sut.roundedCorners(mask, radius: .small)
        #expect(sut.layer.maskedCorners == mask)
        #expect(sut.layer.cornerRadius == 4)
    }

    // MARK: Chainability

    @Test("cornerRadius token overload returns self for chaining")
    func tokenOverloadIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.cornerRadius(.medium)
        #expect(returned === sut)
    }

    @Test("cornerRadius raw overload returns self for chaining")
    func rawOverloadIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.cornerRadius(CGFloat(5))
        #expect(returned === sut)
    }

    @Test("roundedCorners returns self for chaining")
    func roundedCornersIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.roundedCorners(.layerMinXMinYCorner, radius: .small)
        #expect(returned === sut)
    }
}
