# HomerUIKit

Modern Swift 6 / iOS 18 UIKit kit for the Homer suite of Apple apps. A consolidated layer of design tokens and `UIView` extensions that previously lived as copy-pasted snippets across projects — corner radius, shadow, border, Auto Layout pinning, and view-hierarchy helpers built on top of a `Sendable` token system.

- **Swift tools:** 6.0 (`swiftLanguageModes: [.v6]`, strict concurrency)
- **Platforms:** iOS 18+
- **Tests:** Swift Testing
- **Status:** `0.2.0` — public API documented with DocC, 130 tests, 0 warnings

## Installation

Swift Package Manager — add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/akkanferhan/HomerUIKit.git", from: "0.2.0")
]
```

Then attach to a target:

```swift
.target(
    name: "MyApp",
    dependencies: ["HomerUIKit"]
)
```

In code:

```swift
import HomerUIKit
```

## Design tokens

Pure-value, `Sendable` tokens that eliminate magic numbers and strings.

### `Spacing`

| Case | Value |
|---|---|
| `.xs` | 4 pt |
| `.small` | 8 pt |
| `.medium` | 16 pt |
| `.large` | 24 pt |
| `.xl` | 32 pt |
| `.xxl` | 48 pt |

```swift
let inset = Spacing.medium.value           // 16
let oneOff = Spacing.custom(13).value      // 13 — explicit escape hatch
view.pinToSuperview(spacing: .custom(6))   // pass through token-accepting APIs
```

### `CornerRadius`

Discrete cases (`.none / .small / .medium / .large`) plus `.pill` (resolves to half-height) and `.custom(CGFloat)`.

```swift
view.cornerRadius(.medium)                 // 8 pt rounded
view.cornerRadius(.pill)                   // height / 2
let r = CornerRadius.medium.resolved(forHeight: 0)  // 8
```

### `AnimationDuration`

`.fast (0.15) / .standard (0.25) / .slow (0.40) / .custom(TimeInterval)`. `allCases` enumerates only the pre-baked tiers.

### `Alpha`

10 % increments from `.p10` (0.1) to `.p100` (1.0), plus `.custom(CGFloat)` clamped to `0...1` at resolve time.

```swift
view.alpha = Alpha.p50.value               // 0.5
let dim = UIColor.systemRed.withAlphaComponent(Alpha.p20.value)
```

### `TokenColor`

A `Sendable indirect enum` covering system colours, free-form RGBA, fixed black/white at opacity, dynamic light/dark pairing, and asset-catalog references.

```swift
let label: TokenColor = .label
let dim: TokenColor = .black(opacity: 0.5)
let dynamic: TokenColor = .dynamic(
    light: .systemBackground,
    dark: .black(opacity: 1)
)
let resolved: UIColor = label.uiColor      // @MainActor
```

### `BorderStyle` / `ShadowStyle`

`Sendable struct` presets that bundle the four `CALayer` knobs into one value.

```swift
view.border(.standard)                     // 1 pt, separator color
view.applyShadow(.subtle)                  // opacity 0.08, offset (0, 1), radius 2
view.applyShadow(.standard, withCornerRadius: .medium)
```

Host apps can extend the presets:

```swift
extension ShadowStyle {
    static let brand = ShadowStyle(
        color: .custom(red: 0.1, green: 0.2, blue: 0.4, alpha: 1),
        opacity: 0.3,
        offset: CGSize(width: 0, height: 6),
        radius: 16
    )
}
```

## `UIView` extensions

All `@MainActor`. Most return `@discardableResult Self` so calls chain.

### Corner radius

```swift
view.cornerRadius(.medium)
view.roundedCorners(
    [.layerMinXMinYCorner, .layerMaxXMinYCorner],
    radius: .small
)
```

### Shadow

```swift
view.applyShadow(.standard)
view.applyShadow(.standard, withCornerRadius: .medium)
view.updateShadowPathIfNeeded()            // call after frame change
```

### Border

```swift
view.border(.hairline)
view.border(width: 2, color: .red)         // raw escape hatch
```

### Auto Layout

Sets `translatesAutoresizingMaskIntoConstraints = false` and activates constraints. Logs a warning and no-ops when the receiver has no superview.

```swift
child.pinToSuperview()
child.pinToSuperview(spacing: .medium)
child.pinToSuperviewSafeArea(spacing: .large)
child.centerInSuperview()
```

### Hierarchy

```swift
container.addSubviews(headerLabel, bodyLabel, footerView)
container.addSubviews([item1, item2])      // array overload
```

### Dimensions

Chainable, all set `translatesAutoresizingMaskIntoConstraints = false`.

```swift
view
    .setSize(width: 44, height: 44)
    .setMinimumHeight(60)

avatar.setWidth(40).setHeight(40)
```

### `UIEdgeInsets+Spacing`

```swift
let insets = UIEdgeInsets(all: .medium)
let mixed = UIEdgeInsets(horizontal: .small, vertical: .large)
let raw = UIEdgeInsets(horizontal: 13, vertical: 7)  // escape hatch
```

## `UIStackView` extensions

```swift
let stack = UIStackView()
stack.addArrangedSubviews(headerLabel, divider, bodyLabel)
stack.addArrangedSubviews([item1, item2])  // array overload
```

## `UIColor` extensions

`UIColor(hex:)` is a failable initializer that parses 6- or 8-character hex strings (RGB / RGBA), with or without a leading `#`. Whitespace is trimmed; invalid input returns `nil`.

```swift
let brand = UIColor(hex: "#FF6F00")        // RGB
let glassy = UIColor(hex: "FF6F0080")      // RGBA — 50 % alpha
let invalid = UIColor(hex: "not a color")  // nil
```

## Reusable cells

A lightweight `Reusable` protocol gives `UITableViewCell` and `UICollectionViewCell` (via `UICollectionReusableView`) a default reuse identifier — the runtime type name — so registration and dequeuing become type-safe one-liners.

```swift
final class ProductCell: UICollectionViewCell {}

collectionView.register(ProductCell.self)
let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
```

`reuseIdentifier` is overridable for cases where you need a stable string across renames.

## Composition

Token + extension layers compose so common UIKit setup chores collapse to a chain:

```swift
container.addSubviews(card)
card
    .setSize(width: 320, height: 88)
    .cornerRadius(.medium)
    .border(.hairline)
    .applyShadow(.subtle, withCornerRadius: .medium)
    .pinToSuperview(insets: UIEdgeInsets(horizontal: .medium, vertical: .small))
```

## Out of scope

- **SwiftUI** — token primitives are framework-agnostic but no `View`-style API is shipped here. A `HomerUIKitSwiftUI` companion may follow.
- **Snapshot testing** — not bundled to keep the package dependency-free at runtime.
- **Auto-shadow update on bounds change** — planned for v0.3.0; today, call `updateShadowPathIfNeeded()` manually after a frame change.
- **Dark-mode border auto-refresh** — planned for v0.3.0; today, re-apply `border(_:)` in `traitCollectionDidChange(_:)`.

## Development

```bash
xcodebuild build -scheme HomerUIKit -destination 'generic/platform=iOS Simulator'
xcodebuild test  -scheme HomerUIKit -destination 'platform=iOS Simulator,name=iPhone 16'
```

`swift build` / `swift test` are not supported on macOS hosts because UIKit is iOS-only and `HomerFoundation` declares `.macOS(.v14)` — SPM cannot resolve the cross-platform constraint without UIKit available. CI runs the `xcodebuild` commands above on every push and PR.

## License

[MIT](LICENSE) © 2026 Ferhan Akkan
