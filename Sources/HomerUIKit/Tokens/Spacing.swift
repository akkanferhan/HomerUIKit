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

    /// The point value backing the token.
    public var value: CGFloat {
        switch self {
        case .xs: return 4
        case .small: return 8
        case .medium: return 16
        case .large: return 24
        case .xl: return 32
        case .xxl: return 48
        }
    }

    /// Alias for ``value`` for sites that read more naturally as
    /// `someToken.cgFloat`.
    public var cgFloat: CGFloat { value }

    /// Escape hatch returning a raw point value without wrapping it
    /// in a token. Use this when a one-off measurement does not
    /// deserve a new token.
    ///
    /// The static-method shape makes the intent explicit at the call
    /// site: `Spacing.custom(13)` reads as "I know this is not a
    /// token".
    ///
    /// - Parameter value: A point value. Negative values are passed
    ///   through unchanged; the caller is responsible for sign.
    /// - Returns: The same value, untouched.
    public static func custom(_ value: CGFloat) -> CGFloat { value }
}
