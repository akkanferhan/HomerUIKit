import HomerFoundation

/// Module-private logger channel used by HomerUIKit diagnostics
/// (e.g. the no-superview warning emitted by `pinToSuperview*`).
///
/// Centralises the subsystem and category so console filtering by
/// `subsystem:com.homer.uikit` works regardless of the host app's
/// bundle identifier.
internal let log = Log(subsystem: "com.homer.uikit", category: "HomerUIKit")
