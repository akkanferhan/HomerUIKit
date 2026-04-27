import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+Visibility extension")
struct UIViewVisibilityTests {

    // MARK: isVisible getter

    @Test("isVisible returns true when isHidden is false")
    func isVisibleReturnsTrueWhenShown() {
        let sut = ViewFixture.standalone()
        sut.isHidden = false
        #expect(sut.isVisible == true)
    }

    @Test("isVisible returns false when isHidden is true")
    func isVisibleReturnsFalseWhenHidden() {
        let sut = ViewFixture.standalone()
        sut.isHidden = true
        #expect(sut.isVisible == false)
    }

    // MARK: isVisible setter

    @Test("setting isVisible to true clears isHidden")
    func setIsVisibleTrueClearsHidden() {
        let sut = ViewFixture.standalone()
        sut.isHidden = true
        sut.isVisible = true
        #expect(sut.isHidden == false)
    }

    @Test("setting isVisible to false sets isHidden")
    func setIsVisibleFalseSetsHidden() {
        let sut = ViewFixture.standalone()
        sut.isHidden = false
        sut.isVisible = false
        #expect(sut.isHidden == true)
    }

    // MARK: hide() / show()

    @Test("hide sets isHidden to true")
    func hideSetsIsHiddenTrue() {
        let sut = ViewFixture.standalone()
        sut.isHidden = false
        sut.hide()
        #expect(sut.isHidden == true)
    }

    @Test("show sets isHidden to false")
    func showSetsIsHiddenFalse() {
        let sut = ViewFixture.standalone()
        sut.isHidden = true
        sut.show()
        #expect(sut.isHidden == false)
    }

    // MARK: Chainability

    @Test("hide returns self for chaining")
    func hideIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.hide()
        #expect(returned === sut)
    }

    @Test("show returns self for chaining")
    func showIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.show()
        #expect(returned === sut)
    }
}
