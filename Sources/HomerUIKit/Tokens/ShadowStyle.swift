import CoreGraphics

/// A semantic shadow style.
///
/// Maps onto the `CALayer` shadow properties: `shadowColor`,
/// `shadowOpacity`, `shadowOffset`, `shadowRadius`. Use a preset for
/// common elevation tiers, or the memberwise initializer for a
/// custom look.
public struct ShadowStyle: Sendable, Hashable {

    /// Shadow colour token. Resolved via ``TokenColor/uiColor`` at
    /// application time.
    public let color: TokenColor

    /// Shadow opacity (`0...1`). Maps to `CALayer.shadowOpacity`.
    public let opacity: Float

    /// Shadow offset in points. Maps to `CALayer.shadowOffset`.
    public let offset: CGSize

    /// Shadow blur radius in points. Maps to `CALayer.shadowRadius`.
    public let radius: CGFloat

    /// Creates a shadow style.
    public init(
        color: TokenColor,
        opacity: Float,
        offset: CGSize,
        radius: CGFloat
    ) {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
    }

    /// Low-elevation shadow — barely visible, surface-level cards.
    public static let subtle = ShadowStyle(
        color: .black(opacity: 1),
        opacity: 0.08,
        offset: CGSize(width: 0, height: 1),
        radius: 2
    )

    /// Medium-elevation shadow — standard floating cards.
    public static let standard = ShadowStyle(
        color: .black(opacity: 1),
        opacity: 0.15,
        offset: CGSize(width: 0, height: 2),
        radius: 6
    )

    /// High-elevation shadow — modal sheets, popovers.
    public static let prominent = ShadowStyle(
        color: .black(opacity: 1),
        opacity: 0.25,
        offset: CGSize(width: 0, height: 4),
        radius: 12
    )
}
