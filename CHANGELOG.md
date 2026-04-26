# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] — 2026-04-26

Naming cleanup and helper expansion. The `Tokens` namespace and `TokenColor` type are renamed to `Design` / `DesignColor` to better reflect the layer they form, and the short-lived `Reusable` protocol introduced in v0.2.0 is collapsed into an inline `T.description()` lookup. `AlertConfigurable` / `AlertShowable` and `UIApplication.topMostViewController` round out a long-standing alert-presentation gap harvested from FamilyAI.

### Added

- **`AlertConfigurable`** — `@MainActor` protocol describing the data needed to build a `UIAlertController` (style, title, message, actions). Adopt on a value type and pass it to ``AlertShowable``.
- **`AlertShowable`** — `@MainActor` protocol with two presentation paths: a default ``presentAlert(with:)`` that targets the application's top-most view controller (no-op when no scene is foreground-active), and a `where Self: UIViewController` overload ``showAlert(with:)`` that presents on `self`. Both configure the iPad popover anchor automatically.
- **`UIApplication.topMostViewController`** — `@MainActor` extension property that walks the foreground-active scene's key window and unwraps presentation, navigation, and tab-bar containers to reach the visible view controller. Internal `topMost(from:)` helper exposed to `@testable` consumers.

### Changed

- **Breaking — folder rename: `Sources/HomerUIKit/Tokens/` → `Sources/HomerUIKit/Design/`** (mirrored on the test side). Public API names are unchanged for `Spacing`, `CornerRadius`, `AnimationDuration`, `BorderStyle`, `ShadowStyle`, `Alpha`. No source migration required for callers; only repo-relative path references break.
- **Breaking — type rename: `TokenColor` → `DesignColor`.** All references inside `BorderStyle.color` / `ShadowStyle.color`, DocC comments, and tests updated. Migration: search-and-replace `TokenColor` → `DesignColor`. Behaviour unchanged.
- **Breaking — `Reusable` protocol removed.** v0.2.0's `public protocol Reusable` (exposing `static var reuseIdentifier: String`) is gone. The typed `register(_:)` and `dequeueReusableCell<T>(for:)` helpers on `UITableView` and `UICollectionView` now use `T.description()` (NSObject's class-name method) inline. Migration: drop any `Reusable` references; if you overrode `reuseIdentifier`, override `description()` instead. Source files renamed `UI{Table,Collection}View+Reusable.swift` → `UI{Table,Collection}View+Dequeue.swift`.

### Project conventions (unchanged)

- No `Homer`/`FA` prefix.
- Design types stay UIKit-free at the type level; only resolver methods touch `@MainActor`.
- `0.x.y` treats public symbols as semver-stable.

### Known limitations / planned for v0.4.0

- `applyShadow(_:withCornerRadius:)` still requires a manual `updateShadowPathIfNeeded()` after bounds changes.
- `border(_:)` still does not auto-refresh `borderColor` on trait-collection changes.

## [0.2.0] — 2026-04-26

Additions driven by patterns harvested from real iOS apps in the Homer ecosystem (FamilyAI). Tightens the existing surface (one breaking refinement to `Spacing.custom`) and broadens coverage to opacity tokens, hex colours, dimension helpers, stack-view ergonomics, and typed cell dequeuing.

### Added

- **`Alpha` token** — `enum` with 10 % increments (`.p10` … `.p100`) plus `.custom(CGFloat)` clamped to `0...1` at resolve time. `Sendable`, `Hashable`, `CaseIterable` (custom excluded). DocC throughout.
- **`UIColor(hex:)`** — failable convenience initializer parsing 6- or 8-character hex strings (RGB / RGBA), with optional leading `#` and whitespace tolerance.
- **`UIView` dimension helpers** — `setWidth(_:)`, `setHeight(_:)`, `setSize(width:height:)`, `setMinimumHeight(_:)`. All `@MainActor`, all return `@discardableResult Self`, all set `translatesAutoresizingMaskIntoConstraints = false`.
- **`UIStackView.addArrangedSubviews(_:)`** — variadic and `[UIView]` array overloads, mirroring `UIView.addSubviews(_:)`.
- **`Reusable` protocol** — exposes a default `reuseIdentifier` (the runtime type name); `UITableViewCell` and `UICollectionReusableView` (covering `UICollectionViewCell`) conform out of the box. Override per type when stable identifiers are needed.
- **Typed cell dequeue** — `UITableView.register(_:)` + `UITableView.dequeueReusableCell<T>(for:)`, and the matching `UICollectionView` pair. Force-cast under the hood; traps with a clear diagnostic if `register(_:)` was never called for the type.

### Changed

- **Breaking — `Spacing.custom(_:)` is now a case, not a static func.** Previously `Spacing.custom(13)` returned `CGFloat` (`13`). It now returns `Spacing` (a token wrapping the value), so it can be passed wherever a `Spacing` is expected (e.g. `view.pinToSuperview(spacing: .custom(6))`). Migration:
  - **Before:** `let raw: CGFloat = Spacing.custom(13)`
  - **After:** `let raw: CGFloat = Spacing.custom(13).value`
  - Token-accepting APIs benefit directly: `.pinToSuperview(spacing: .custom(13))`.
  - Documented in `Spacing.swift` DocC and in this entry. The api-designer flagged this as a v0.2.0 follow-up at v0.1.0 ship time.

### Project conventions (unchanged from v0.1.0)

- No `Homer`/`FA` prefix.
- Tokens stay UIKit-free at the type level; only resolver methods touch `@MainActor`.
- `0.x.y` treats public symbols as semver-stable.

### Known limitations / planned for v0.3.0

- `applyShadow(_:withCornerRadius:)` still requires a manual `updateShadowPathIfNeeded()` after bounds changes; auto-update lands in v0.3.0.
- `border(_:)` does not auto-refresh `borderColor` on trait-collection changes; v0.3.0 will add a trait observer.

## [0.1.0] — 2026-04-26

Initial release. UIKit extensions and design tokens for the Homer suite, built on top of `HomerFoundation`. Strict concurrency, Swift Testing, DocC throughout.

### Added

- **Design tokens** — `Spacing`, `CornerRadius`, `AnimationDuration`, `BorderStyle`, `ShadowStyle`, `TokenColor`. All `Sendable`. Discrete tokens are `enum` (with `Hashable`/`CaseIterable` where applicable); composite tokens (`BorderStyle`, `ShadowStyle`) are `struct` with static presets that host apps can extend.
- **`TokenColor`** — `indirect enum` covering system colours, fixed black/white at opacity, free-form RGBA, dynamic light/dark pairing, and asset-catalog references; resolves to `UIColor` on the main actor with component clamping.
- **`UIView` extensions** — `cornerRadius(_:)`, `roundedCorners(_:radius:)`, `applyShadow(_:)`, `applyShadow(_:withCornerRadius:)`, `updateShadowPathIfNeeded()`, `border(_:)`, `pinToSuperview(insets:)`, `pinToSuperview(spacing:)`, `pinToSuperviewSafeArea(insets:)`, `pinToSuperviewSafeArea(spacing:)`, `centerInSuperview()`, `addSubviews(_:)`. All `@MainActor`. Most return `@discardableResult Self` for chaining.
- **`UIEdgeInsets` extensions** — `init(all:)` and `init(horizontal:vertical:)` (token + raw `CGFloat` overloads).
- **Internal logging** — fixed `com.homer.uikit` subsystem channel so Console filtering by subsystem works regardless of the host app's bundle identifier.
- DocC documentation across the entire public API.
- Swift Testing suite — 98 tests across 12 suites, including ARC-safe parented view fixtures and a hand-rolled trait-collection resolver for `TokenColor.dynamic`.

### Project conventions

- No `Homer`/`FA` prefix — the module namespace handles disambiguation.
- Tokens never depend on UIKit extensions; extensions consume tokens. Tokens stay `Sendable`; only the resolver methods are `@MainActor`.
- `0.x.y` versioning treats public symbols as semver-stable: removing or renaming a case or method, tightening conformances, or raising the deployment target counts as a breaking change.

### Known limitations / planned for v0.2.0+

- `applyShadow(_:withCornerRadius:)` requires a manual `updateShadowPathIfNeeded()` after bounds changes.
- `border(_:)` does not auto-refresh `borderColor` on trait-collection changes (light/dark mode); re-apply in `traitCollectionDidChange(_:)` if you need it.
- No `UIStackView.addArrangedSubviews(_:)` helper yet.

[Unreleased]: https://github.com/akkanferhan/HomerUIKit/compare/0.3.0...HEAD
[0.3.0]: https://github.com/akkanferhan/HomerUIKit/releases/tag/0.3.0
[0.2.0]: https://github.com/akkanferhan/HomerUIKit/releases/tag/0.2.0
[0.1.0]: https://github.com/akkanferhan/HomerUIKit/releases/tag/0.1.0
