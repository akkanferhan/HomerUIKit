import Testing
import CoreGraphics
@testable import HomerUIKit

@Suite("CornerRadius token")
struct CornerRadiusTests {

    // MARK: rawValue

    @Test(
        "rawValue returns documented CGFloat for fixed cases",
        arguments: [
            (CornerRadius.none, CGFloat?(0)),
            (CornerRadius.small, CGFloat?(4)),
            (CornerRadius.medium, CGFloat?(8)),
            (CornerRadius.large, CGFloat?(16)),
            (CornerRadius.custom(7), CGFloat?(7))
        ]
    )
    func rawValueForFixedCases(pair: (CornerRadius, CGFloat?)) {
        let (token, expected) = pair
        #expect(token.rawValue == expected)
    }

    @Test("pill rawValue is nil because it is contextual")
    func pillRawValueIsNil() {
        #expect(CornerRadius.pill.rawValue == nil)
    }

    // MARK: resolved(forHeight:)

    @Test("none resolves to 0 for any height")
    func noneResolvedToZero() {
        #expect(CornerRadius.none.resolved(forHeight: 100) == 0)
    }

    @Test("medium resolves to 8 for any height")
    func mediumResolvedToEight() {
        #expect(CornerRadius.medium.resolved(forHeight: 100) == 8)
    }

    @Test("pill resolves to half of the provided height")
    func pillResolvedToHalfHeight() {
        #expect(CornerRadius.pill.resolved(forHeight: 100) == 50)
    }

    @Test("custom value passes through resolved")
    func customResolvedPassthrough() {
        #expect(CornerRadius.custom(20).resolved(forHeight: 100) == 20)
    }

    @Test("pill with negative height clamps to 0 without crashing")
    func pillNegativeHeightClampsToZero() {
        #expect(CornerRadius.pill.resolved(forHeight: -10) == 0)
    }

    // MARK: Hashable

    @Test("identical cases are equal")
    func equalCases() {
        #expect(CornerRadius.medium == CornerRadius.medium)
    }

    @Test("different cases are not equal")
    func unequalCases() {
        #expect(CornerRadius.small != CornerRadius.large)
    }
}
