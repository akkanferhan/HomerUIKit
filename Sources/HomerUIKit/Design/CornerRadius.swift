import CoreGraphics

/// A semantic corner-radius token.
///
/// Most cases carry a fixed point value, but ``pill`` is contextual —
/// it resolves to half of the view's height — and ``custom(_:)`` lets
/// callers carry a one-off value through the same token type rather
/// than splitting the API into "raw" and "token" overloads.
public enum CornerRadius: Sendable, Hashable {

    /// No rounding — sharp corners.
    case none

    /// 4 pt — subtle softening, e.g. inline tags.
    case small

    /// 8 pt — standard control / card rounding.
    case medium

    /// 16 pt — large surfaces, sheet-like containers.
    case large

    /// Pill shape — resolves at layout time to half of the host
    /// view's height. Use ``resolved(forHeight:)`` to compute.
    case pill

    /// A caller-supplied point value carried through the token type.
    case custom(CGFloat)

    /// The fixed point value of this token, or `nil` when the token
    /// is contextual (currently only ``pill``).
    ///
    /// Prefer ``resolved(forHeight:)`` if you need a value you can
    /// hand directly to `CALayer.cornerRadius`.
    public var rawValue: CGFloat? {
        switch self {
        case .none: return 0
        case .small: return 4
        case .medium: return 8
        case .large: return 16
        case .pill: return nil
        case .custom(let value): return value
        }
    }

    /// Resolves this token to a concrete radius for a given view
    /// height. Non-contextual cases ignore the input.
    ///
    /// - Parameter height: The view height that ``pill`` will be
    ///   resolved against.
    /// - Returns: A point value safe to assign to
    ///   `CALayer.cornerRadius`.
    public func resolved(forHeight height: CGFloat) -> CGFloat {
        switch self {
        case .pill: return max(0, height) / 2
        default: return rawValue ?? 0
        }
    }
}
