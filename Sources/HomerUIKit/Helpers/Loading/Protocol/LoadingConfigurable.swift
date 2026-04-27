//
//  LoadingConfigurable.swift
//  HomerUIKit
//
//  Created by Ferhan on 27.04.2026.
//

import Foundation

/// Describes the appearance of the global loading indicator presented
/// by ``LoadingManager``.
///
/// Conform a value type to `LoadingConfigurable` and pass it to
/// ``LoadingManagerProtocol/configure(with:)`` to customise the
/// indicator without subclassing the manager. Values are read on the
/// next ``LoadingManagerProtocol/show()`` call.
@MainActor
public protocol LoadingConfigurable {

    /// When `true` the spinner is framed by a translucent dark card,
    /// drawing the eye to the loading affordance. When `false` the
    /// spinner sits directly on the dim overlay.
    var loadingIndicatorHasBackground: Bool { get }
}
