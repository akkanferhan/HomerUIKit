import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UILabel convenience initializer")
struct UILabelConvenienceTests {

    // MARK: Defaults

    @Test("default init produces a label with nil text and 1 line")
    func defaultInit() {
        let label = UILabel()
        let convenience = UILabel(text: nil)
        #expect(convenience.text == nil)
        #expect(convenience.numberOfLines == 1)
        #expect(convenience.textAlignment == .natural)
        // Convenience init keeps system defaults when font/textColor are nil.
        #expect(convenience.font == label.font)
    }

    // MARK: Stored values

    @Test("text is stored when provided")
    func storesText() {
        let label = UILabel(text: "Hello")
        #expect(label.text == "Hello")
    }

    @Test("font is stored when provided")
    func storesFont() {
        let font = UIFont.systemFont(ofSize: 22)
        let label = UILabel(font: font)
        #expect(label.font == font)
    }

    @Test("textColor is stored when provided")
    func storesTextColor() {
        let label = UILabel(textColor: .systemRed)
        #expect(label.textColor == UIColor.systemRed)
    }

    @Test("textAlignment is stored when provided")
    func storesTextAlignment() {
        let label = UILabel(textAlignment: .center)
        #expect(label.textAlignment == .center)
    }

    @Test("numberOfLines is stored when provided")
    func storesNumberOfLines() {
        let label = UILabel(numberOfLines: 0)
        #expect(label.numberOfLines == 0)
    }

    // MARK: Combined

    @Test("all parameters combine into the expected configuration")
    func combinedConfiguration() {
        let font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let label = UILabel(
            text: "Welcome",
            font: font,
            textColor: .label,
            textAlignment: .center,
            numberOfLines: 0
        )
        #expect(label.text == "Welcome")
        #expect(label.font == font)
        #expect(label.textColor == UIColor.label)
        #expect(label.textAlignment == .center)
        #expect(label.numberOfLines == 0)
    }
}
