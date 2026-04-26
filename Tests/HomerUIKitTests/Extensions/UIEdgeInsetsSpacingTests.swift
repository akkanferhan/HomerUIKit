import Testing
import UIKit
@testable import HomerUIKit

@Suite("UIEdgeInsets+Spacing extension")
struct UIEdgeInsetsSpacingTests {

    // MARK: init(all:)

    @Test("init(all:.medium) produces uniform 16pt insets on all edges")
    func allMediumProducesUniform16() {
        let insets = UIEdgeInsets(all: .medium)
        #expect(insets == UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }

    @Test("init(all:.xs) produces uniform 4pt insets on all edges")
    func allXsProducesUniform4() {
        let insets = UIEdgeInsets(all: .xs)
        #expect(insets == UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }

    // MARK: init(horizontal:vertical:) — token overload

    @Test("init(horizontal:.small, vertical:.large) maps to top/bottom=24 and left/right=8")
    func horizontalSmallVerticalLargeMapping() {
        let insets = UIEdgeInsets(horizontal: .small, vertical: .large)
        #expect(insets.top == 24)
        #expect(insets.bottom == 24)
        #expect(insets.left == 8)
        #expect(insets.right == 8)
    }

    @Test("init(horizontal:.medium, vertical:.medium) is equal to init(all:.medium)")
    func symmetricHorizontalVerticalEqualsAll() {
        let fromAxes = UIEdgeInsets(horizontal: .medium, vertical: .medium)
        let fromAll = UIEdgeInsets(all: .medium)
        #expect(fromAxes == fromAll)
    }

    // MARK: init(horizontal:vertical:) — raw CGFloat overload

    @Test("init(horizontal:5, vertical:10) maps to top/bottom=10 and left/right=5")
    func rawHorizontalVerticalMapping() {
        let insets = UIEdgeInsets(horizontal: CGFloat(5), vertical: CGFloat(10))
        #expect(insets.top == 10)
        #expect(insets.bottom == 10)
        #expect(insets.left == 5)
        #expect(insets.right == 5)
    }

    @Test("init(horizontal:0, vertical:0) produces zero insets")
    func rawZeroProducesZeroInsets() {
        let insets = UIEdgeInsets(horizontal: CGFloat(0), vertical: CGFloat(0))
        #expect(insets == .zero)
    }
}
