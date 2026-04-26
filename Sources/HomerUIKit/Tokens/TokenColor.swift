import UIKit

/// A semantic colour token.
///
/// `TokenColor` is `Sendable` and pure-value; it does not touch UIKit
/// until ``uiColor`` is read on the main actor. The enum supports
/// system colours, fixed black/white at a chosen opacity, free-form
/// RGBA, dynamic light/dark pairing, and asset-catalog lookups.
///
/// Hashing semantics:
/// - ``asset(name:bundle:)`` hashes by the bundle's object identity
///   (`Bundle: Hashable` is provided by `NSObject`), not by its
///   contents. Two `Bundle?` references to the same bundle hash
///   equal.
public indirect enum TokenColor: Sendable, Hashable {

    /// Maps to `UIColor.label`.
    case label

    /// Maps to `UIColor.secondaryLabel`.
    case secondaryLabel

    /// Maps to `UIColor.tertiaryLabel`.
    case tertiaryLabel

    /// Maps to `UIColor.separator`.
    case separator

    /// Maps to `UIColor.systemBackground`.
    case systemBackground

    /// Maps to `UIColor.secondarySystemBackground`.
    case secondarySystemBackground

    /// Fully transparent colour — `UIColor.clear`.
    case clear

    /// Solid black at the given opacity. The component is clamped to
    /// `0...1` at resolve time.
    case black(opacity: Double)

    /// Solid white at the given opacity. The component is clamped to
    /// `0...1` at resolve time.
    case white(opacity: Double)

    /// A free-form RGBA colour. Components are clamped to `0...1` at
    /// resolve time.
    case custom(red: Double, green: Double, blue: Double, alpha: Double)

    /// A colour that resolves differently in light vs. dark mode.
    /// Implemented under the hood via
    /// `UIColor(dynamicProvider:)`.
    case dynamic(light: TokenColor, dark: TokenColor)

    /// A colour loaded from an asset catalog.
    ///
    /// - Parameters:
    ///   - name: The asset name as it appears in the catalog.
    ///   - bundle: The bundle hosting the asset, or `nil` to fall
    ///     back to `Bundle.main`.
    case asset(name: String, bundle: Bundle?)

    /// Resolves the token to a concrete `UIColor`.
    ///
    /// Must be read on the main actor: the resolver constructs
    /// `UIColor` instances that may bind to the trait collection
    /// (`.dynamic`) or load from asset catalogs (`.asset`). Missing
    /// asset lookups fall back to ``TokenColor/clear``.
    @MainActor
    public var uiColor: UIColor {
        switch self {
        case .label: return .label
        case .secondaryLabel: return .secondaryLabel
        case .tertiaryLabel: return .tertiaryLabel
        case .separator: return .separator
        case .systemBackground: return .systemBackground
        case .secondarySystemBackground: return .secondarySystemBackground
        case .clear: return .clear
        case .black(let opacity):
            return UIColor(white: 0, alpha: clamp(opacity))
        case .white(let opacity):
            return UIColor(white: 1, alpha: clamp(opacity))
        case .custom(let red, let green, let blue, let alpha):
            return UIColor(
                red: clamp(red),
                green: clamp(green),
                blue: clamp(blue),
                alpha: clamp(alpha)
            )
        case .dynamic(let light, let dark):
            return UIColor { trait in
                let token: TokenColor = (trait.userInterfaceStyle == .dark) ? dark : light
                return MainActor.assumeIsolated { token.uiColor }
            }
        case .asset(let name, let bundle):
            return UIColor(named: name, in: bundle, compatibleWith: nil) ?? .clear
        }
    }
}

private func clamp(_ value: Double) -> CGFloat {
    CGFloat(min(1, max(0, value)))
}
