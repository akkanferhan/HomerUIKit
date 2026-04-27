import HomerFoundation
import UIKit

@MainActor
public extension UIView {

    /// Pins all four edges of the receiver to its superview's edges
    /// with the given insets and activates the constraints.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false` on
    /// the receiver. If the receiver has no superview, logs a
    /// warning and returns without activating anything.
    ///
    /// - Parameter insets: Edge insets, defaulting to `.zero`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperview(insets: UIEdgeInsets = .zero) -> Self {
        guard let superview else {
            log.warning("pinToSuperview called on a view with no superview")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
        return self
    }

    /// Convenience that pins all four edges with an equal token-based
    /// inset on every side.
    ///
    /// - Parameter spacing: A spacing token applied to all four
    ///   edges.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperview(spacing: Spacing) -> Self {
        pinToSuperview(insets: UIEdgeInsets(all: spacing))
    }

    /// Pins all four edges of the receiver to its superview's
    /// `safeAreaLayoutGuide` with the given insets.
    ///
    /// - Parameter insets: Edge insets, defaulting to `.zero`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperviewSafeArea(insets: UIEdgeInsets = .zero) -> Self {
        guard let superview else {
            log.warning("pinToSuperviewSafeArea called on a view with no superview")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        let safe = superview.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safe.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -insets.bottom)
        ])
        return self
    }

    /// Pins all four edges to the superview's safe area with an
    /// equal token-based inset on every side.
    ///
    /// - Parameter spacing: A spacing token applied to all four
    ///   edges.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func pinToSuperviewSafeArea(spacing: Spacing) -> Self {
        pinToSuperviewSafeArea(insets: UIEdgeInsets(all: spacing))
    }

    /// Centers the receiver in its superview by activating
    /// `centerXAnchor` and `centerYAnchor` constraints.
    ///
    /// If the receiver has no superview, logs a warning and returns
    /// without activating anything.
    ///
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func centerInSuperview() -> Self {
        guard let superview else {
            log.warning("centerInSuperview called on a view with no superview")
            return self
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
        return self
    }

    /// Centers the receiver in its superview and applies a fixed
    /// width / height in a single call.
    ///
    /// Composition of ``centerInSuperview()`` and ``setWidth(_:)`` /
    /// ``setHeight(_:)`` — provided as a convenience for the common
    /// "modal card centred at a fixed size" pattern. Components
    /// equal to or below `0` are skipped, so passing `.zero` reduces
    /// to a pure centring call.
    ///
    /// - Parameter size: Fixed dimensions to apply alongside
    ///   centering. Pass `.zero` (or set a single component to `0`)
    ///   to skip the width or height constraint.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func centerInSuperview(size: CGSize) -> Self {
        centerInSuperview()
        if size.width > 0 {
            setWidth(size.width)
        }
        if size.height > 0 {
            setHeight(size.height)
        }
        return self
    }

    /// Pins the receiver's edges to the supplied anchors, applies
    /// the given padding, and (optionally) sets fixed width/height.
    /// Edges that are not supplied are left unconstrained.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false` on
    /// the receiver and activates every produced constraint before
    /// returning. Useful when the layout mixes anchors from
    /// different ancestors — e.g. a sibling's `bottomAnchor` with
    /// the parent's `safeAreaLayoutGuide.topAnchor`.
    ///
    /// ```swift
    /// label.anchor(
    ///     top: titleLabel.bottomAnchor,
    ///     leading: superview.leadingAnchor,
    ///     trailing: superview.trailingAnchor,
    ///     padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - top: Optional top anchor.
    ///   - leading: Optional leading anchor.
    ///   - bottom: Optional bottom anchor.
    ///   - trailing: Optional trailing anchor.
    ///   - padding: Per-edge insets applied as constraint constants.
    ///     Top and leading are added directly; bottom and trailing
    ///     are negated, so positive values always move the edge
    ///     inwards.
    ///   - size: Fixed width / height in points. Components equal
    ///     to `0` are skipped — pass non-zero values only for the
    ///     dimensions you want pinned.
    /// - Returns: The activated constraints in declaration order
    ///   (top, leading, bottom, trailing, width, height) for any
    ///   edges you supplied.
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []

        if let top {
            constraints.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        if let leading {
            constraints.append(leadingAnchor.constraint(equalTo: leading, constant: padding.left))
        }
        if let bottom {
            constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        if let trailing {
            constraints.append(trailingAnchor.constraint(equalTo: trailing, constant: -padding.right))
        }
        if size.width != 0 {
            constraints.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        if size.height != 0 {
            constraints.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Centers the receiver horizontally inside the given view and,
    /// optionally, pins its top to a specific anchor.
    ///
    /// Use when the receiver should align with another view's
    /// centre on the X axis but float vertically — for example a
    /// title centred horizontally beneath a header that supplies
    /// its own top anchor.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`. The
    /// receiver does not need to be a direct subview of `view`;
    /// any view in a shared layout hierarchy works.
    ///
    /// - Parameters:
    ///   - view: The view whose `centerXAnchor` is used as the
    ///     alignment target.
    ///   - topAnchor: Optional anchor the receiver's `topAnchor` is
    ///     pinned to. Pass `nil` to leave vertical positioning to
    ///     surrounding constraints.
    ///   - paddingTop: Constant added to the top constraint when
    ///     `topAnchor` is non-`nil`. Defaults to `0`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func centerX(
        inView view: UIView,
        topAnchor: NSLayoutYAxisAnchor? = nil,
        paddingTop: CGFloat = 0
    ) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if let topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop).isActive = true
        }
        return self
    }

    /// Centers the receiver vertically inside the given view and,
    /// optionally, pins its leading edge to a specific anchor.
    ///
    /// The Y-axis counterpart to
    /// ``centerX(inView:topAnchor:paddingTop:)``. Useful for icons
    /// that should align vertically with a label's centre while
    /// sitting at a fixed horizontal offset.
    ///
    /// Sets `translatesAutoresizingMaskIntoConstraints = false`. The
    /// receiver does not need to be a direct subview of `view`.
    ///
    /// - Parameters:
    ///   - view: The view whose `centerYAnchor` is used as the
    ///     alignment target.
    ///   - leadingAnchor: Optional anchor the receiver's
    ///     `leadingAnchor` is pinned to. Pass `nil` to leave
    ///     horizontal positioning to surrounding constraints.
    ///   - paddingLeading: Constant added to the leading constraint
    ///     when `leadingAnchor` is non-`nil`. Defaults to `0`.
    /// - Returns: `self`, so calls can be chained.
    @discardableResult
    func centerY(
        inView view: UIView,
        leadingAnchor: NSLayoutXAxisAnchor? = nil,
        paddingLeading: CGFloat = 0
    ) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        if let leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeading).isActive = true
        }
        return self
    }
}
