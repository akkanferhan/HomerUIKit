import Testing
import Foundation
@testable import HomerUIKit

@Suite("AnimationDuration token")
struct AnimationDurationTests {

    @Test(
        "each named case maps to its documented TimeInterval",
        arguments: [
            (AnimationDuration.fast, 0.15),
            (AnimationDuration.standard, 0.25),
            (AnimationDuration.slow, 0.40)
        ]
    )
    func namedCaseValue(pair: (AnimationDuration, TimeInterval)) {
        let (token, expected) = pair
        #expect(token.value == expected)
    }

    @Test("custom value passes through unchanged")
    func customPassthrough() {
        #expect(AnimationDuration.custom(2.5).value == 2.5)
    }

    @Test("allCases contains exactly fast, standard, slow — no custom")
    func allCasesExcludesCustom() {
        #expect(AnimationDuration.allCases == [.fast, .standard, .slow])
    }

    @Test("allCases count is 3")
    func allCasesCount() {
        #expect(AnimationDuration.allCases.count == 3)
    }
}
