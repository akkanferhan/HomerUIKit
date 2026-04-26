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

    @Test("custom passes through positive value unchanged")
    func customPassthroughPositive() {
        #expect(Spacing.custom(13) == 13)
    }

    @Test("custom passes through negative value unchanged")
    func customPassthroughNegative() {
        #expect(Spacing.custom(-5) == -5)
    }

    @Test("allCases contains exactly 6 named cases")
    func allCasesCount() {
        #expect(Spacing.allCases.count == 6)
    }
}
