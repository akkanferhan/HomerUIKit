import Testing
import CoreGraphics
@testable import HomerUIKit

@Suite("Alpha token")
struct AlphaTests {

    @Test(
        "each preset case maps to its documented opacity",
        arguments: [
            (Alpha.p10, CGFloat(0.1)),
            (Alpha.p20, CGFloat(0.2)),
            (Alpha.p30, CGFloat(0.3)),
            (Alpha.p40, CGFloat(0.4)),
            (Alpha.p50, CGFloat(0.5)),
            (Alpha.p60, CGFloat(0.6)),
            (Alpha.p70, CGFloat(0.7)),
            (Alpha.p80, CGFloat(0.8)),
            (Alpha.p90, CGFloat(0.9)),
            (Alpha.p100, CGFloat(1.0))
        ]
    )
    func presetMaps(pair: (Alpha, CGFloat)) {
        let (token, expected) = pair
        #expect(token.value == expected)
    }

    @Test("custom carries an in-range value through unchanged")
    func customInRange() {
        #expect(Alpha.custom(0.42).value == 0.42)
    }

    @Test("custom clamps a negative value to 0")
    func customBelowRange() {
        #expect(Alpha.custom(-0.5).value == 0)
    }

    @Test("custom clamps a value above 1 to 1")
    func customAboveRange() {
        #expect(Alpha.custom(2.0).value == 1)
    }

    @Test("custom is Equatable on its associated value")
    func customEquality() {
        #expect(Alpha.custom(0.3) == Alpha.custom(0.3))
        #expect(Alpha.custom(0.3) != Alpha.custom(0.4))
    }

    @Test("allCases contains the 10 preset cases and excludes custom")
    func allCasesExcludesCustom() {
        #expect(Alpha.allCases == [.p10, .p20, .p30, .p40, .p50, .p60, .p70, .p80, .p90, .p100])
    }
}
