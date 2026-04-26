import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIView+Shadow extension")
struct UIViewShadowTests {

    // MARK: applyShadow(_:)

    @Test("applyShadow(.standard) sets all layer shadow properties correctly")
    func applyShadowStandardSetsAllProperties() {
        let sut = ViewFixture.standalone()
        sut.applyShadow(.standard)
        #expect(sut.layer.shadowOpacity == 0.15)
        #expect(sut.layer.shadowOffset == CGSize(width: 0, height: 2))
        #expect(sut.layer.shadowRadius == 6)
        #expect(sut.layer.shadowColor != nil)
        #expect(sut.clipsToBounds == false)
    }

    // MARK: applyShadow(_:withCornerRadius:)

    @Test("applyShadow with corner radius sets cornerRadius, non-nil path, and clipsToBounds false")
    func applyShadowWithCornerRadiusSetsPath() {
        let sut = ViewFixture.standalone(size: CGSize(width: 200, height: 100))
        sut.applyShadow(.standard, withCornerRadius: .medium)
        #expect(sut.layer.cornerRadius == 8)
        #expect(sut.layer.shadowPath != nil)
        #expect(sut.clipsToBounds == false)
    }

    // MARK: updateShadowPathIfNeeded()

    @Test("updateShadowPathIfNeeded is a no-op when shadow path is nil")
    func updateShadowPathNoOpWhenNil() {
        let sut = ViewFixture.standalone()
        // No shadow applied — path is nil
        #expect(sut.layer.shadowPath == nil)
        sut.updateShadowPathIfNeeded()
        #expect(sut.layer.shadowPath == nil)
    }

    @Test("updateShadowPathIfNeeded refreshes path bounding box after frame change")
    func updateShadowPathRefreshesAfterFrameChange() throws {
        let sut = ViewFixture.standalone(size: CGSize(width: 100, height: 50))
        sut.applyShadow(.standard, withCornerRadius: .medium)

        // Change the frame to a new size
        sut.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        sut.updateShadowPathIfNeeded()

        let path = try #require(sut.layer.shadowPath)
        let boundingBox = path.boundingBox
        #expect(boundingBox.width == 200)
        #expect(boundingBox.height == 80)
    }

    // MARK: Chainability

    @Test("applyShadow returns self for chaining")
    func applyShadowIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.applyShadow(.standard)
        #expect(returned === sut)
    }

    @Test("applyShadow with corner radius returns self for chaining")
    func applyShadowWithCornerRadiusIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.applyShadow(.standard, withCornerRadius: .medium)
        #expect(returned === sut)
    }

    @Test("updateShadowPathIfNeeded returns self for chaining")
    func updateShadowPathIsChainable() {
        let sut = ViewFixture.standalone()
        let returned = sut.updateShadowPathIfNeeded()
        #expect(returned === sut)
    }
}
