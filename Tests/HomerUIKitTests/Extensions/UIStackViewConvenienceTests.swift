import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIStackView convenience initializer")
struct UIStackViewConvenienceTests {

    // MARK: Token spacing overload

    @Test("token-spacing init applies axis, spacing, alignment, and distribution")
    func tokenInitAppliesAllProperties() {
        let stack = UIStackView(
            axis: .vertical,
            spacing: .medium,
            alignment: .leading,
            distribution: .fillEqually
        )
        #expect(stack.axis == .vertical)
        #expect(stack.spacing == 16)
        #expect(stack.alignment == .leading)
        #expect(stack.distribution == .fillEqually)
    }

    @Test("token-spacing init seeds arranged subviews in order")
    func tokenInitSeedsArrangedSubviews() {
        let a = UIView()
        let b = UIView()
        let c = UIView()
        let stack = UIStackView(
            axis: .horizontal,
            spacing: .small,
            arrangedSubviews: [a, b, c]
        )
        #expect(stack.arrangedSubviews == [a, b, c])
    }

    @Test("token-spacing init with .custom passes through the raw value")
    func tokenInitCustomSpacing() {
        let stack = UIStackView(
            axis: .horizontal,
            spacing: .custom(13)
        )
        #expect(stack.spacing == 13)
    }

    @Test("token-spacing init defaults alignment to .fill and distribution to .fill")
    func tokenInitDefaults() {
        let stack = UIStackView(
            axis: .horizontal,
            spacing: .small
        )
        #expect(stack.alignment == .fill)
        #expect(stack.distribution == .fill)
    }

    // MARK: Raw spacing overload

    @Test("raw-spacing init applies the explicit CGFloat spacing")
    func rawInitAppliesSpacing() {
        let stack = UIStackView(
            axis: .horizontal,
            spacing: CGFloat(7),
            alignment: .center,
            distribution: .equalSpacing
        )
        #expect(stack.axis == .horizontal)
        #expect(stack.spacing == 7)
        #expect(stack.alignment == .center)
        #expect(stack.distribution == .equalSpacing)
    }

    @Test("raw-spacing init seeds arranged subviews in order")
    func rawInitSeedsArrangedSubviews() {
        let a = UIView()
        let b = UIView()
        let stack = UIStackView(
            axis: .vertical,
            spacing: CGFloat(0),
            arrangedSubviews: [a, b]
        )
        #expect(stack.arrangedSubviews == [a, b])
    }
}
