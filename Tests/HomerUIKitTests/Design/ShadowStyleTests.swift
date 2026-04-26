import Testing
import CoreGraphics
@testable import HomerUIKit

@Suite("ShadowStyle token")
struct ShadowStyleTests {

    // MARK: subtle preset

    @Test("subtle preset opacity is 0.08")
    func subtleOpacity() {
        #expect(ShadowStyle.subtle.opacity == 0.08)
    }

    @Test("subtle preset offset is (0, 1)")
    func subtleOffset() {
        #expect(ShadowStyle.subtle.offset == CGSize(width: 0, height: 1))
    }

    @Test("subtle preset radius is 2")
    func subtleRadius() {
        #expect(ShadowStyle.subtle.radius == 2)
    }

    @Test("subtle preset color is black opacity 1")
    func subtleColor() {
        #expect(ShadowStyle.subtle.color == .black(opacity: 1))
    }

    // MARK: standard preset

    @Test("standard preset opacity is 0.15")
    func standardOpacity() {
        #expect(ShadowStyle.standard.opacity == 0.15)
    }

    @Test("standard preset offset is (0, 2)")
    func standardOffset() {
        #expect(ShadowStyle.standard.offset == CGSize(width: 0, height: 2))
    }

    @Test("standard preset radius is 6")
    func standardRadius() {
        #expect(ShadowStyle.standard.radius == 6)
    }

    // MARK: prominent preset

    @Test("prominent preset opacity is 0.25")
    func prominentOpacity() {
        #expect(ShadowStyle.prominent.opacity == 0.25)
    }

    @Test("prominent preset offset is (0, 4)")
    func prominentOffset() {
        #expect(ShadowStyle.prominent.offset == CGSize(width: 0, height: 4))
    }

    @Test("prominent preset radius is 12")
    func prominentRadius() {
        #expect(ShadowStyle.prominent.radius == 12)
    }

    // MARK: Memberwise init round-trip

    @Test("memberwise init stores all four properties as provided")
    func memberwiseInitRoundTrip() {
        let style = ShadowStyle(
            color: .label,
            opacity: 0.5,
            offset: CGSize(width: 1, height: 3),
            radius: 10
        )
        #expect(style.color == .label)
        #expect(style.opacity == 0.5)
        #expect(style.offset == CGSize(width: 1, height: 3))
        #expect(style.radius == 10)
    }

    // MARK: Equatable / Hashable

    @Test("identical presets are equal")
    func equalPresets() {
        #expect(ShadowStyle.standard == ShadowStyle.standard)
    }

    @Test("subtle and standard presets are not equal")
    func differentPresetsNotEqual() {
        #expect(ShadowStyle.subtle != ShadowStyle.standard)
    }

    @Test("memberwise-built style equals the equivalent preset")
    func memberwiseBuildMatchesPreset() {
        let built = ShadowStyle(
            color: .black(opacity: 1),
            opacity: 0.15,
            offset: CGSize(width: 0, height: 2),
            radius: 6
        )
        #expect(built == ShadowStyle.standard)
    }
}
