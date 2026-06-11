import Foundation

/// Unregisters a block-based `NotificationCenter` observer when the
/// owner deallocates. Owning the token through this box (instead of a
/// raw `any NSObjectProtocol` property) sidesteps Swift 6's ban on
/// touching non-`Sendable` state from a nonisolated `deinit`;
/// `removeObserver` is documented thread-safe.
///
/// Shared by ``AlertManager`` and ``LoadingManager`` for their
/// scene-activation retry observers.
final class NotificationObserverToken: @unchecked Sendable {
    private let token: any NSObjectProtocol

    init(_ token: any NSObjectProtocol) {
        self.token = token
    }

    deinit {
        NotificationCenter.default.removeObserver(token)
    }
}
