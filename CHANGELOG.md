# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

### Known limitations / planned for v0.2.0

- `applyShadow(_:withCornerRadius:)` requires a manual `updateShadowPathIfNeeded()` after bounds changes; v0.2.0 will lift this requirement.
- `border(_:)` does not auto-refresh `borderColor` on trait-collection changes (light/dark mode); re-apply in `traitCollectionDidChange(_:)` if you need it.
- No `UIStackView.addArrangedSubviews(_:)` helper yet — coming in v0.2.0.

[Unreleased]: https://github.com/akkanferhan/HomerUIKit/compare/0.1.0...HEAD
[0.1.0]: https://github.com/akkanferhan/HomerUIKit/releases/tag/0.1.0
