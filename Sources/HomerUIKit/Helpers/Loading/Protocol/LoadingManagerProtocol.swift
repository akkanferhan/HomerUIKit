//
//  LoadingManagerProtocol.swift
//  HomerUIKit
//
//  Created by Ferhan on 27.04.2026.
//

import UIKit

/// The behavioural surface of ``LoadingManager``. Depend on this
/// protocol — not the concrete class — when a consumer needs to
/// drive the global loading indicator so unit tests can swap in a
/// mock implementation.
@MainActor
public protocol LoadingManagerProtocol: AnyObject {

    /// Reference-counted show. The indicator becomes visible on the
    /// first call; subsequent calls increment an internal counter.
    /// Each ``show()`` must be matched by a ``hide()``.
    func show()

    /// Decrements the show counter. The indicator is dismissed once
    /// the counter returns to zero. Calls beyond the matching
    /// ``show()`` are clamped — never produce a negative count.
    func hide()

    /// Resets the counter to zero and tears down the indicator
    /// window immediately. Use after a global error or sign-out
    /// flow when pending ``show()`` calls cannot be reliably matched.
    func forceHide()

    /// Customises the indicator's appearance. Optional — when
    /// never called, defaults apply. Subsequent calls override
    /// prior settings; the next ``show()`` reflects the change.
    func configure(with configuration: any LoadingConfigurable)
}
