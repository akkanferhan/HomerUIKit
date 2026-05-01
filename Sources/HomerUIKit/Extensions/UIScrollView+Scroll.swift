import UIKit

@MainActor
public extension UIScrollView {

    /// Scrolls to the top-leading content offset, accounting for the
    /// adjusted content inset (`safeAreaInsets`, `contentInset`, and
    /// keyboard avoidance combined).
    ///
    /// Use in `viewWillAppear(_:)` after a tab reselection or after a
    /// data reload that should drop the user back at the top of the
    /// list.
    ///
    /// ```swift
    /// scrollView.scrollToTop()
    /// ```
    ///
    /// - Parameter animated: Whether the offset change is animated.
    ///   Defaults to `true`.
    func scrollToTop(animated: Bool = true) {
        let offset = CGPoint(
            x: -adjustedContentInset.left,
            y: -adjustedContentInset.top
        )
        setContentOffset(offset, animated: animated)
    }

    /// Scrolls so the bottom of the content area is visible, accounting
    /// for the adjusted content inset.
    ///
    /// When the content is shorter than the bounds (no scrolling
    /// required), falls back to the same offset ``scrollToTop(animated:)``
    /// would produce, so the call is always a no-op-or-snap rather than
    /// a layout-thrashing jump.
    ///
    /// ```swift
    /// scrollView.scrollToBottom()
    /// ```
    ///
    /// - Parameter animated: Whether the offset change is animated.
    ///   Defaults to `true`.
    func scrollToBottom(animated: Bool = true) {
        let topY = -adjustedContentInset.top
        let maxY = contentSize.height - bounds.height + adjustedContentInset.bottom
        let bottomY = max(topY, maxY)
        let offset = CGPoint(
            x: -adjustedContentInset.left,
            y: bottomY
        )
        setContentOffset(offset, animated: animated)
    }
}
