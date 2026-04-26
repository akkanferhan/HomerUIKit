import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+Border extension")
struct UIViewBorderTests {

    // MARK: Token-based border

    @Test("border(.standard) sets borderWidth to 1 and non-nil borderColor")
    func borderStandardSetsWidthAndColor() {
        let sut = ViewFixture.standalone()
        sut.border(.standard)
        #expect(sut.layer.borderWidth == 1)
        #expect(sut.layer.borderColor != nil)
    }

    @Test("border(.hairline) sets borderWidth to 0.5")
    func borderHairlineSetsHalfPoint() {
        let sut = ViewFixture.standalone()
        sut.border(.hairline)
        #expect(sut.layer.borderWidth == 0.5)
    }

    @Test("border(.emphasized) sets borderWidth to 2")
    func borderEmphasizedSetsTwoPoints() {
        let sut = ViewFixture.standalone()
        sut.border(.emphasized)
        #expect(sut.layer.borderWidth == 2)
    }

    // MARK: Raw width + UIColor overload

    @Test("border(width:color:) sets the exact raw width")
    func rawBorderSetsExactWidth() {
        let sut = ViewFixture.standalone()
        sut.border(width: 3, color: .red)
        #expect(sut.layer.borderWidth == 3)
    }

    @Test("border(width:color:) sets borderColor to the provided color's cgColor")
    func rawBorderSetsColor() {
        let sut = ViewFixture.standalone()
        sut.border(width: 3, color: .red)
        let expectedCG = UIColor.red.cgColor
        #expect(sut.layer.borderColor == expectedCG)
    }

    // MARK: Chainability

    @Test("border token overload returns self for chaining")
    func borderTokenIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.border(.standard)
        #expect(returned === sut)
    }

    @Test("border raw overload returns self for chaining")
    func borderRawIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.border(width: 1, color: .blue)
        #expect(returned === sut)
    }
}
