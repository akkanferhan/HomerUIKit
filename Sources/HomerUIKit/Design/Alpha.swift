import CoreGraphics

/// A semantic alpha (opacity) token.
///
/// Pre-baked cases cover the standard 10 % increments used in most
/// design systems (`p10` = 0.1 through `p100` = 1.0). Use
/// ``custom(_:)`` for one-off values; out-of-range inputs are
/// clamped to `0...1` at resolve time, matching `UIView.alpha` and
/// `UIColor.withAlphaComponent(_:)` semantics.
public enum Alpha: Sendable, Hashable, CaseIterable {

    /// 0.1 — barely visible.
    case p10

    /// 0.2.
    case p20

    /// 0.3.
    case p30

    /// 0.4.
    case p40

    /// 0.5 — half-transparent.
    case p50

    /// 0.6.
    case p60

    /// 0.7.
    case p70

    /// 0.8.
    case p80

    /// 0.9.
    case p90

    /// 1.0 — fully opaque.
    case p100

    /// A caller-supplied value, clamped to `0...1` at resolve time.
    case custom(CGFloat)

    /// The 10 pre-baked cases. ``custom(_:)`` is excluded by
    /// definition — `CaseIterable` cannot enumerate a case with an
    /// associated value.
    public static var allCases: [Alpha] {
        [.p10, .p20, .p30, .p40, .p50, .p60, .p70, .p80, .p90, .p100]
    }

    /// The opacity value backing the token, in the range `0...1`.
    public var value: CGFloat {
        switch self {
        case .p10: return 0.1
        case .p20: return 0.2
        case .p30: return 0.3
        case .p40: return 0.4
        case .p50: return 0.5
        case .p60: return 0.6
        case .p70: return 0.7
        case .p80: return 0.8
        case .p90: return 0.9
        case .p100: return 1.0
        case .custom(let value): return min(1, max(0, value))
        }
    }
}
