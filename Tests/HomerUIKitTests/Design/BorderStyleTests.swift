import Testing
import CoreGraphics
@testable import HomerUIKit

@Suite("BorderStyle token")
struct BorderStyleTests {

    // MARK: Static presets

    @Test("hairline preset has width 0.5")
    func hairlineWidth() {
        #expect(BorderStyle.hairline.width == 0.5)
    }

    @Test("hairline preset uses separator color")
    func hairlineColor() {
        #expect(BorderStyle.hairline.color == .separator)
    }

    @Test("standard preset has width 1")
    func standardWidth() {
        #expect(BorderStyle.standard.width == 1)
    }

    @Test("standard preset uses separator color")
    func standardColor() {
        #expect(BorderStyle.standard.color == .separator)
    }

    @Test("emphasized preset has width 2")
    func emphasizedWidth() {
        #expect(BorderStyle.emphasized.width == 2)
    }

    @Test("emphasized preset uses separator color")
    func emphasizedColor() {
        #expect(BorderStyle.emphasized.color == .separator)
    }

    // MARK: Memberwise init round-trip

    @Test("memberwise init stores width and color as provided")
    func memberwiseInitRoundTrip() {
        let style = BorderStyle(width: 3.5, color: .label)
        #expect(style.width == 3.5)
        #expect(style.color == .label)
    }

    // MARK: Equatable / Hashable

    @Test("two equal border styles are equal")
    func equalStyles() {
        #expect(BorderStyle.standard == BorderStyle.standard)
    }

    @Test("hairline and standard are not equal")
    func differentStylesNotEqual() {
        #expect(BorderStyle.hairline != BorderStyle.standard)
    }

    @Test("memberwise-built style equals the equivalent preset")
    func memberwiseBuildMatchesPreset() {
        let built = BorderStyle(width: 1, color: .separator)
        #expect(built == BorderStyle.standard)
    }
}
