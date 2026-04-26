import Foundation

/// A semantic animation-duration token.
///
/// Pre-baked durations cover the common micro-interaction tiers; use
/// ``custom(_:)`` when a designer specifies a precise number.
public enum AnimationDuration: Sendable, Hashable, CaseIterable {

    /// 0.15 s — micro-feedback, e.g. button press states.
    case fast

    /// 0.25 s — the default for most UIKit-style transitions.
    case standard

    /// 0.40 s — deliberate, attention-drawing motion.
    case slow

    /// A caller-supplied duration in seconds.
    case custom(TimeInterval)

    /// The pre-baked tiers. The ``custom(_:)`` case is excluded by
    /// definition — `CaseIterable` cannot enumerate a case with an
    /// associated value, so this list is hand-written and contains
    /// only ``fast``, ``standard``, and ``slow``.
    public static var allCases: [AnimationDuration] {
        [.fast, .standard, .slow]
    }

    /// Duration in seconds suitable for
    /// `UIView.animate(withDuration:)`.
    public var value: TimeInterval {
        switch self {
        case .fast: return 0.15
        case .standard: return 0.25
        case .slow: return 0.4
        case .custom(let value): return value
        }
    }
}
