import Testing
import UIKit
@testable import HomerUIKit

@Suite("UIStackView arranged-subview helpers")
@MainActor
struct UIStackViewHierarchyTests {

    @Test("variadic addArrangedSubviews appends in order")
    func variadicAppendsInOrder() {
        let stack = UIStackView()
        let a = UIView(), b = UIView(), c = UIView()
        stack.addArrangedSubviews(a, b, c)
        #expect(stack.arrangedSubviews == [a, b, c])
    }

    @Test("variadic addArrangedSubviews with one view")
    func variadicSingle() {
        let stack = UIStackView()
        let only = UIView()
        stack.addArrangedSubviews(only)
        #expect(stack.arrangedSubviews == [only])
    }

    @Test("variadic addArrangedSubviews with no views is a no-op")
    func variadicEmpty() {
        let stack = UIStackView()
        stack.addArrangedSubviews()
        #expect(stack.arrangedSubviews.isEmpty)
    }

    @Test("array addArrangedSubviews appends in order")
    func arrayAppendsInOrder() {
        let stack = UIStackView()
        let a = UIView(), b = UIView()
        stack.addArrangedSubviews([a, b])
        #expect(stack.arrangedSubviews == [a, b])
    }

    @Test("array addArrangedSubviews with empty array is a no-op")
    func arrayEmpty() {
        let stack = UIStackView()
        stack.addArrangedSubviews([])
        #expect(stack.arrangedSubviews.isEmpty)
    }

    @Test("addArrangedSubviews appends to the existing arrangement")
    func appendsAfterExisting() {
        let stack = UIStackView()
        let first = UIView()
        stack.addArrangedSubview(first)
        let later = UIView()
        stack.addArrangedSubviews(later)
        #expect(stack.arrangedSubviews == [first, later])
    }

    // MARK: removeAllArrangedSubviews

    @Test("removeAllArrangedSubviews empties arrangedSubviews")
    func removeAllEmptiesArrangement() {
        let stack = UIStackView()
        stack.addArrangedSubviews(UIView(), UIView(), UIView())
        #expect(stack.arrangedSubviews.count == 3)
        stack.removeAllArrangedSubviews()
        #expect(stack.arrangedSubviews.isEmpty)
    }

    @Test("removeAllArrangedSubviews also detaches views from the regular hierarchy")
    func removeAllDetachesFromSubviews() {
        let stack = UIStackView()
        let a = UIView(), b = UIView()
        stack.addArrangedSubviews(a, b)
        stack.removeAllArrangedSubviews()
        #expect(stack.subviews.contains(a) == false)
        #expect(stack.subviews.contains(b) == false)
        #expect(a.superview == nil)
        #expect(b.superview == nil)
    }

    @Test("removeAllArrangedSubviews on an empty stack is a no-op")
    func removeAllOnEmptyStackNoCrash() {
        let stack = UIStackView()
        stack.removeAllArrangedSubviews()
        #expect(stack.arrangedSubviews.isEmpty)
    }
}
