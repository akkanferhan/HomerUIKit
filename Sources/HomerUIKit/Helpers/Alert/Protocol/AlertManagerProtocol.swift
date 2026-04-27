//
//  AlertManagerProtocol.swift
//  HomerUIKit
//
//  Created by Ferhan on 27.04.2026.
//

import UIKit

/// The behavioural surface of ``AlertManager``. Depend on this
/// protocol — not the concrete class — when a consumer needs to
/// surface alerts so unit tests can swap in a mock implementation.
@MainActor
public protocol AlertManagerProtocol: AnyObject {

    /// Adds a configuration to the FIFO queue. If no alert is
    /// presenting, the new alert is shown immediately; otherwise it
    /// waits its turn behind any earlier enqueues.
    func enqueue(_ configuration: any AlertConfigurable)

    /// Drops every pending alert that has not yet been shown. The
    /// alert currently on screen, if any, continues to show until
    /// the user dismisses it; afterwards the manager becomes idle.
    func removeAll()
}
