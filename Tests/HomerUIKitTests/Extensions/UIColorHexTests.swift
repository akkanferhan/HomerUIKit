import Testing
import UIKit
@testable import HomerUIKit

@Suite("UIColor(hex:)")
@MainActor
struct UIColorHexTests {

    // MARK: - Valid input

    @Test("parses pure red without leading hash")
    func plainRed() throws {
        let color = try #require(UIColor(hex: "FF0000"))
        let components = try #require(color.cgColor.components)
        #expect(components[0] == 1)
        #expect(components[1] == 0)
        #expect(components[2] == 0)
        #expect(components[3] == 1)
    }

    @Test("parses pure green with leading hash")
    func hashedGreen() throws {
        let color = try #require(UIColor(hex: "#00FF00"))
        let components = try #require(color.cgColor.components)
        #expect(components[0] == 0)
        #expect(components[1] == 1)
        #expect(components[2] == 0)
    }

    @Test("parses 8-char hex with alpha")
    func rgbaHex() throws {
        let color = try #require(UIColor(hex: "#FF000080"))
        let components = try #require(color.cgColor.components)
        #expect(components[0] == 1)
        #expect(components[1] == 0)
        #expect(components[2] == 0)
        // 0x80 = 128; 128/255 ≈ 0.502 — accept a tiny epsilon
        #expect(abs(components[3] - 128.0 / 255.0) < 0.001)
    }

    @Test("trims surrounding whitespace")
    func whitespaceTrim() throws {
        let color = try #require(UIColor(hex: "  #0000FF\n"))
        let components = try #require(color.cgColor.components)
        #expect(components[2] == 1)
    }

    @Test("accepts lowercase hex digits")
    func lowercase() throws {
        let upper = try #require(UIColor(hex: "ABCDEF"))
        let lower = try #require(UIColor(hex: "abcdef"))
        #expect(upper == lower)
    }

    // MARK: - Invalid input

    @Test(
        "rejects malformed input",
        arguments: [
            "",
            "#",
            "ABC",                  // 3 chars — short form not supported
            "ABCD",
            "ABCDE",
            "ABCDEFG",              // 7 chars — neither 6 nor 8
            "GG0000",               // contains non-hex digit
            "not a color",
            "#XYZXYZ",
            "🎨🎨🎨🎨🎨🎨"
        ]
    )
    func malformedReturnsNil(input: String) {
        #expect(UIColor(hex: input) == nil)
    }
}
