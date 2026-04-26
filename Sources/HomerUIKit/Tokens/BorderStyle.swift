import CoreGraphics

/// A semantic border style: width plus colour.
///
/// Use the static presets for the common cases; the memberwise
/// initializer is exposed for one-offs.
public struct BorderStyle: Sendable, Hashable {

    /// Stroke width in points.
    public let width: CGFloat

    /// Stroke colour, expressed as a token.
    public let color: TokenColor

    /// Creates a border style.
    /// - Parameters:
    ///   - width: Stroke width in points.
    ///   - color: Stroke colour token.
    public init(width: CGFloat, color: TokenColor) {
        self.width = width
        self.color = color
    }

    /// 0.5 pt wide — approximates a single device pixel on @2x
    /// displays. Defaults to ``TokenColor/separator``.
    public static let hairline = BorderStyle(width: 0.5, color: .separator)

    /// 1 pt wide. Defaults to ``TokenColor/separator``.
    public static let standard = BorderStyle(width: 1, color: .separator)

    /// 2 pt wide. Defaults to ``TokenColor/separator``.
    public static let emphasized = BorderStyle(width: 2, color: .separator)
}
