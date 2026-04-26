import UIKit

public extension UIEdgeInsets {

    /// Insets with the same spacing token on every edge.
    ///
    /// - Parameter spacing: A spacing token applied to all four
    ///   edges.
    init(all spacing: Spacing) {
        let value = spacing.value
        self.init(top: value, left: value, bottom: value, right: value)
    }

    /// Insets with one spacing token applied to the leading/trailing
    /// edges and another to the top/bottom edges.
    ///
    /// - Parameters:
    ///   - horizontal: Spacing for `left` and `right`.
    ///   - vertical: Spacing for `top` and `bottom`.
    init(horizontal: Spacing, vertical: Spacing) {
        self.init(
            top: vertical.value,
            left: horizontal.value,
            bottom: vertical.value,
            right: horizontal.value
        )
    }

    /// Insets with raw point values for the horizontal and vertical
    /// axes. Provided as an escape hatch when the values do not
    /// correspond to tokens.
    ///
    /// - Parameters:
    ///   - horizontal: Point inset for `left` and `right`.
    ///   - vertical: Point inset for `top` and `bottom`.
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
}
