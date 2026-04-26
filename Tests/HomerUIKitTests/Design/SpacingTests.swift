import Testing
import CoreGraphics
@testable import HomerUIKit

@Suite("Spacing token")
struct SpacingTests {

    @Test(
        "each named case resolves to its documented CGFloat",
        arguments: [
            (Spacing.xs, CGFloat(4)),
            (Spacing.small, CGFloat(8)),
            (Spacing.medium, CGFloat(16)),
            (Spacing.large, CGFloat(24)),
            (Spacing.xl, CGFloat(32)),
            (Spacing.xxl, CGFloat(48))
        ]
    )
    func namedCaseValue(pair: (Spacing, CGFloat)) {
        let (token, expected) = pair
        #expect(token.value == expected)
    }

    @Test("cgFloat is an alias for value")
    func cgFloatAliasMatchesValue() {
        #expect(Spacing.medium.cgFloat == Spacing.medium.value)
    }

    @Test("custom carries positive value via .value")
    func customPositive() {
        #expect(Spacing.custom(13).value == 13)
    }

    @Test("custom carries negative value via .value")
    func customNegative() {
        #expect(Spacing.custom(-5).value == -5)
    }

    @Test("custom is Equatable on its associated value")
    func customEquality() {
        #expect(Spacing.custom(7) == Spacing.custom(7))
        #expect(Spacing.custom(7) != Spacing.custom(8))
    }

    @Test("allCases contains exactly 6 preset cases and excludes custom")
    func allCasesExcludesCustom() {
        #expect(Spacing.allCases == [.xs, .small, .medium, .large, .xl, .xxl])
    }
}
