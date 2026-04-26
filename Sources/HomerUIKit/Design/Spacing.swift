import CoreGraphics

/// A semantic spacing token.
///
/// Use these cases for layout insets, stack spacings, and any other
/// dimension a designer would call "small / medium / large". The raw
/// point values are deliberately fixed; if you need a one-off value
/// that does not match a token, prefer ``Spacing/custom(_:)`` so the
/// intent ("escape hatch") is explicit at the call site.
public enum Spacing: Sendable, Hashable, CaseIterable {

    /// 4 pt — tight grouping, e.g. icon-to-label inside a chip.
    case xs

    /// 8 pt — default tight padding, e.g. inside a small badge.
    case small

    /// 16 pt — the standard content inset; use this when in doubt.
    case medium

    /// 24 pt — section padding, generous content margin.
    case large

    /// 32 pt — separation between major content groups.
    case xl

    /// 48 pt — hero-level vertical rhythm.
    case xxl

    /// A caller-supplied point value carried through the token type.
    ///
    /// Use this when a one-off measurement does not deserve a new
    /// preset case but you still need to pass a `Spacing` to a
    /// token-accepting API: `view.pinToSuperview(spacing: .custom(6))`.
    /// Negative values are carried through unchanged.
    case custom(CGFloat)

    /// The pre-baked named cases. The ``custom(_:)`` case is excluded
    /// by definition — `CaseIterable` cannot enumerate a case with an
    /// associated value, so this list is hand-written and contains
    /// only ``xs``, ``small``, ``medium``, ``large``, ``xl``, and
    /// ``xxl``.
    public static var allCases: [Spacing] {
        [.xs, .small, .medium, .large, .xl, .xxl]
    }

    /// The point value backing the token.
    public var value: CGFloat {
        switch self {
        case .xs: return 4
        case .small: return 8
        case .medium: return 16
        case .large: return 24
        case .xl: return 32
        case .xxl: return 48
        case .custom(let value): return value
        }
    }

    /// Alias for ``value`` for sites that read more naturally as
    /// `someToken.cgFloat`.
    public var cgFloat: CGFloat { value }
}
