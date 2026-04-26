import UIKit

/// Factory helpers for UIView instances used in extension tests.
///
/// All methods are `@MainActor` because `UIView` construction must happen
/// on the main thread. Each test creates fresh views via these helpers to
/// guarantee isolation.
@MainActor
enum ViewFixture {

    /// A standalone view at a fixed size with no superview.
    ///
    /// - Parameter size: The frame size to apply. Defaults to 100×50.
    /// - Returns: A newly created `UIView` with `frame` set to `size`.
    static func standalone(size: CGSize = CGSize(width: 100, height: 50)) -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        return view
    }

    /// A child view added to a container view of a fixed size.
    ///
    /// The container has its `bounds` set so safe-area calculations
    /// work sensibly in constraint tests. No `UIWindow` is involved;
    /// for v0.1.0 we only verify constraint *activation*, not layout
    /// passes.
    ///
    /// - Parameters:
    ///   - childSize: Frame size for the child view. Defaults to 100×50.
    ///   - containerSize: Frame size for the container. Defaults to 320×480.
    /// - Returns: A tuple of `(child, container)` where child is already
    ///   a subview of container.
    static func parented(
        childSize: CGSize = CGSize(width: 100, height: 50),
        containerSize: CGSize = CGSize(width: 320, height: 480)
    ) -> (child: UIView, container: UIView) {
        let container = UIView(frame: CGRect(origin: .zero, size: containerSize))
        let child = UIView(frame: CGRect(origin: .zero, size: childSize))
        container.addSubview(child)
        return (child, container)
    }
}
