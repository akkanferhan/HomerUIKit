import UIKit

@MainActor
public extension UIStackView {

    /// Convenience initializer that bundles axis, spacing, alignment,
    /// and distribution into a single call — and accepts an initial
    /// list of arranged subviews via a ``Spacing`` token.
    ///
    /// ```swift
    /// let stack = UIStackView(
    ///     axis: .vertical,
    ///     spacing: .medium,
    ///     alignment: .leading,
    ///     distribution: .fill,
    ///     arrangedSubviews: [titleLabel, bodyLabel, footerView]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - axis: The stack's primary axis.
    ///   - spacing: Inter-item spacing as a design token.
    ///   - alignment: Cross-axis alignment, defaulting to ``UIStackView/Alignment/fill``.
    ///   - distribution: Main-axis distribution, defaulting to ``UIStackView/Distribution/fill``.
    ///   - arrangedSubviews: Initial arranged subviews, in order.
    convenience init(
        axis: NSLayoutConstraint.Axis,
        spacing: Spacing,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing.value
        self.alignment = alignment
        self.distribution = distribution
    }

    /// Convenience initializer accepting a raw `CGFloat` spacing.
    ///
    /// Provided as an escape hatch when the spacing does not match a
    /// ``Spacing`` token — prefer the token overload where possible.
    ///
    /// - Parameters:
    ///   - axis: The stack's primary axis.
    ///   - spacing: Inter-item spacing in points.
    ///   - alignment: Cross-axis alignment, defaulting to ``UIStackView/Alignment/fill``.
    ///   - distribution: Main-axis distribution, defaulting to ``UIStackView/Distribution/fill``.
    ///   - arrangedSubviews: Initial arranged subviews, in order.
    convenience init(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}
