import Testing
import UIKit
@testable import HomerUIKit

@MainActor
@Suite("UIScrollView+Scroll extension")
struct UIScrollViewScrollTests {

    private func makeScrollView(
        bounds: CGRect = CGRect(x: 0, y: 0, width: 320, height: 480),
        contentSize: CGSize = CGSize(width: 320, height: 1000),
        contentInset: UIEdgeInsets = .zero
    ) -> UIScrollView {
        let scrollView = UIScrollView(frame: bounds)
        scrollView.contentSize = contentSize
        scrollView.contentInset = contentInset
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }

    // MARK: scrollToTop

    @Test("scrollToTop with zero inset lands at .zero")
    func scrollToTopZeroInset() {
        let scrollView = makeScrollView()
        scrollView.contentOffset = CGPoint(x: 10, y: 200)
        scrollView.scrollToTop(animated: false)
        #expect(scrollView.contentOffset == .zero)
    }

    @Test("scrollToTop accounts for adjusted content inset")
    func scrollToTopHonoursContentInset() {
        let inset = UIEdgeInsets(top: 44, left: 8, bottom: 0, right: 0)
        let scrollView = makeScrollView(contentInset: inset)
        scrollView.contentOffset = CGPoint(x: 100, y: 600)
        scrollView.scrollToTop(animated: false)
        #expect(scrollView.contentOffset == CGPoint(x: -8, y: -44))
    }

    // MARK: scrollToBottom

    @Test("scrollToBottom lands at contentHeight - boundsHeight")
    func scrollToBottomLandsAtBottom() {
        let scrollView = makeScrollView()
        scrollView.scrollToBottom(animated: false)
        let expected: CGFloat = 1000 - 480
        #expect(scrollView.contentOffset.y == expected)
    }

    @Test("scrollToBottom adds the bottom inset")
    func scrollToBottomHonoursBottomInset() {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        let scrollView = makeScrollView(contentInset: inset)
        scrollView.scrollToBottom(animated: false)
        let expected: CGFloat = 1000 - 480 + 60
        #expect(scrollView.contentOffset.y == expected)
    }

    @Test("scrollToBottom on under-filled content snaps to top instead of going negative")
    func scrollToBottomShortContent() {
        let scrollView = makeScrollView(
            contentSize: CGSize(width: 320, height: 100),
            contentInset: UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        )
        scrollView.scrollToBottom(animated: false)
        #expect(scrollView.contentOffset.y == -44)
    }
}
