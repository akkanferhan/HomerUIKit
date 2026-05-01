import UIKit

@MainActor
public extension UIViewController {

    /// Attaches the supplied child view controller to the receiver
    /// using the canonical UIKit three-step containment dance.
    ///
    /// 1. ``UIViewController/addChild(_:)``
    /// 2. The child's view is added to `container` (or the receiver's
    ///    own ``view``) and pinned to all four edges with `insets`.
    /// 3. ``UIViewController/didMove(toParent:)`` with the receiver.
    ///
    /// Call sites usually handle the first and third steps but forget
    /// the second, leaving the child view controller logically attached
    /// but visually missing — this helper makes it impossible to skip a
    /// step.
    ///
    /// ```swift
    /// attachChild(headerVC, in: headerContainer)
    /// attachChild(content)               // pinned to self.view
    /// attachChild(banner, insets: UIEdgeInsets(all: .small))
    /// ```
    ///
    /// - Parameters:
    ///   - child: The view controller to attach.
    ///   - container: Optional host view for the child's view. Defaults
    ///     to the receiver's own ``view``.
    ///   - insets: Edge insets used when pinning the child's view.
    ///     Defaults to `.zero`.
    func attachChild(
        _ child: UIViewController,
        in container: UIView? = nil,
        insets: UIEdgeInsets = .zero
    ) {
        let host: UIView = container ?? view
        addChild(child)
        host.addSubview(child.view)
        child.view.pinToSuperview(insets: insets)
        child.didMove(toParent: self)
    }

    /// Detaches the receiver from its parent view controller using the
    /// symmetric three-step removal:
    ///
    /// 1. ``UIViewController/willMove(toParent:)`` with `nil`.
    /// 2. ``UIView/removeFromSuperview()``.
    /// 3. ``UIViewController/removeFromParent()``.
    ///
    /// No-op when the receiver has no parent.
    func detachFromParent() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
