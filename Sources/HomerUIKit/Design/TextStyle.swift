import UIKit

/// A semantic typography token.
///
/// The named cases map one-to-one onto `UIFont.TextStyle`, so their
/// ``font`` participates in Dynamic Type automatically via
/// `preferredFont(forTextStyle:)`. Use ``custom(size:weight:)`` when a
/// designer specifies a precise, fixed size that has no semantic tier —
/// like the other tokens' `custom` cases, it is the explicit escape
/// hatch and deliberately does **not** scale with the user's content
/// size preferences.
///
/// ```swift
/// let title = UILabel.dynamicType(style: .headline)
/// let badge = UILabel.dynamicType(style: .custom(size: 11, weight: .semibold))
/// ```
public enum TextStyle: Sendable, Hashable, CaseIterable {

    /// Maps to `UIFont.TextStyle.largeTitle` — screen-level hero text.
    case largeTitle

    /// Maps to `UIFont.TextStyle.title1` — primary section title.
    case title

    /// Maps to `UIFont.TextStyle.title2` — secondary title tier.
    case title2

    /// Maps to `UIFont.TextStyle.title3` — tertiary title tier.
    case title3

    /// Maps to `UIFont.TextStyle.headline` — emphasised body-level text.
    case headline

    /// Maps to `UIFont.TextStyle.subheadline` — supporting line under a headline.
    case subheadline

    /// Maps to `UIFont.TextStyle.body` — the default reading tier; use when in doubt.
    case body

    /// Maps to `UIFont.TextStyle.callout` — slightly tighter than body.
    case callout

    /// Maps to `UIFont.TextStyle.footnote` — ancillary information.
    case footnote

    /// Maps to `UIFont.TextStyle.caption1` — labels on images and controls.
    case caption

    /// Maps to `UIFont.TextStyle.caption2` — the smallest semantic tier.
    case caption2

    /// A caller-supplied fixed size and weight carried through the
    /// token type. Does **not** participate in Dynamic Type — prefer a
    /// named tier whenever one fits.
    case custom(size: CGFloat, weight: UIFont.Weight)

    /// The pre-baked named cases. The ``custom(size:weight:)`` case is
    /// excluded by definition — `CaseIterable` cannot enumerate a case
    /// with an associated value, so this list is hand-written.
    public static var allCases: [TextStyle] {
        [
            .largeTitle, .title, .title2, .title3,
            .headline, .subheadline, .body, .callout,
            .footnote, .caption, .caption2
        ]
    }

    /// The `UIFont.TextStyle` backing a named tier, or `nil` for
    /// ``custom(size:weight:)``.
    public var uiTextStyle: UIFont.TextStyle? {
        switch self {
        case .largeTitle: return .largeTitle
        case .title: return .title1
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption: return .caption1
        case .caption2: return .caption2
        case .custom: return nil
        }
    }

    /// The font backing the token. Named tiers resolve through
    /// `preferredFont(forTextStyle:)`, so they reflect the user's
    /// current content size category; pair with
    /// `adjustsFontForContentSizeCategory = true` (or the
    /// ``UIKit/UILabel/dynamicType(style:color:numberOfLines:textAlignment:)-swift.type.method``
    /// factory) to track changes live. ``custom(size:weight:)``
    /// resolves to a fixed `systemFont(ofSize:weight:)`.
    public var font: UIFont {
        switch self {
        case .custom(let size, let weight):
            return .systemFont(ofSize: size, weight: weight)
        default:
            // Force-unwrap is safe: only `custom` returns nil above.
            return .preferredFont(forTextStyle: uiTextStyle!)
        }
    }
}
