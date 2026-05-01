# HomerUIKit

Modern Swift 6 / iOS 18 UIKit kit for the Homer suite of Apple apps. A consolidated layer of design system primitives, `UIView` extensions, and helper protocols that previously lived as copy-pasted snippets across projects — corner radius, shadow, border, Auto Layout pinning, view-hierarchy helpers, hex colours, dimension setters, typed cell dequeue, and alert presentation, built on top of a `Sendable` design system.

- **Swift tools:** 6.0 (`swiftLanguageModes: [.v6]`, strict concurrency)
- **Platforms:** iOS 18+
- **Tests:** Swift Testing
- **Status:** `0.8.0` — public API documented with DocC, 241 tests, 0 warnings

## Installation

Swift Package Manager — add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/akkanferhan/HomerUIKit.git", from: "0.8.0")
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

## Design system

Pure-value, `Sendable` design primitives (under `Sources/HomerUIKit/Design/`) that eliminate magic numbers and strings.

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

### `DesignColor`

A `Sendable indirect enum` covering system colours, free-form RGBA, fixed black/white at opacity, dynamic light/dark pairing, and asset-catalog references.

```swift
let label: DesignColor = .label
let dim: DesignColor = .black(opacity: 0.5)
let dynamic: DesignColor = .dynamic(
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

// Add and pin in a single call:
container.embed(card, insets: UIEdgeInsets(all: .medium))
container.embed(card, spacing: .medium)    // token overload

container.removeAllSubviews()              // empties subviews in declaration order
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

// Empties arrangedSubviews *and* removes them from the regular subview
// hierarchy — `removeArrangedSubview(_:)` alone leaves them parented.
stack.removeAllArrangedSubviews()
```

## `UIControl` / `UIButton` extensions

Closure-based action handlers and `UIButton.Configuration` factories so
the target/action selector boilerplate disappears from call sites.

```swift
button.addAction(for: .touchUpInside) { [weak self] _ in
    self?.handleTap()
}

let save = UIButton.filled(title: "Save", image: UIImage(systemName: "checkmark"))
let cancel = UIButton.tinted(title: "Cancel", tintColor: .systemRed)
let skip = UIButton.plain(title: "Skip")
let info = UIButton.bordered(title: "Learn more")
```

`addAction(for:_:)` returns the created `UIAction` so callers can detach
it later via `removeAction(_:for:)`.

## `UIScrollView` extensions

```swift
scrollView.scrollToTop()                   // animated by default
scrollView.scrollToBottom(animated: false)
```

Both helpers honour the adjusted content inset (safe area + content
inset + keyboard avoidance combined). `scrollToBottom` snaps to the top
offset when content is shorter than the bounds, so the call is always a
no-op-or-snap rather than a layout-thrashing jump.

## `UIViewController` extensions

Single-call equivalents of the canonical UIKit child-containment dance —
`addChild` → add `view` to host + pin → `didMove(toParent:)` — and its
symmetric removal:

```swift
attachChild(headerVC, in: headerContainer)
attachChild(content)                        // pinned to self.view
attachChild(banner, insets: UIEdgeInsets(all: .small))

child.detachFromParent()                    // willMove → removeFromSuperview → removeFromParent
```

## `UIColor` extensions

`UIColor(hex:)` is a failable initializer that parses 6- or 8-character hex strings (RGB / RGBA), with or without a leading `#`. Whitespace is trimmed; invalid input returns `nil`.

```swift
let brand = UIColor(hex: "#FF6F00")        // RGB
let glassy = UIColor(hex: "FF6F0080")      // RGBA — 50 % alpha
let invalid = UIColor(hex: "not a color")  // nil
```

## Typed cell dequeue

Generic `register(_:)` + `dequeueReusableCell(for:)` overloads on `UITableView` and `UICollectionView` use the cell type's runtime name (`T.description()`) as the reuse identifier — no protocol boilerplate, no string identifiers.

```swift
final class ProductCell: UICollectionViewCell {}

collectionView.register(ProductCell.self)
let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
```

If a registered class has a custom `description()` (rare; only happens with explicit `+description` overrides), that name is used instead — handy when you want a stable identifier across renames.

## Helpers

### `UIApplication.topMostViewController`

Walks the foreground-active scene's key window and unwraps `presentedViewController`, `UINavigationController`, and `UITabBarController` to reach the view controller the user is actually looking at. Returns `nil` when no foreground-active scene exists.

```swift
let visible = UIApplication.shared.topMostViewController
```

### Alerts — `AlertConfigurable` + `AlertShowable`

Describe an alert as a value (title + message + style + actions) and present it from any context: a coordinator, a manager, or a `UIViewController` directly.

```swift
struct ConfirmDelete: AlertConfigurable {
    let style: UIAlertController.Style = .alert
    let title: String? = "Delete account?"
    let message: String? = "This cannot be undone."
    let actions: [UIAlertAction] = [
        UIAlertAction(title: "Cancel", style: .cancel),
        UIAlertAction(title: "Delete", style: .destructive) { _ in /* … */ }
    ]
}

// From a coordinator / manager — presents on the top-most VC:
final class AccountCoordinator: AlertShowable { /* … */ }
coordinator.presentAlert(with: ConfirmDelete())

// From a UIViewController — presents on self:
final class SettingsVC: UIViewController, AlertShowable { /* … */ }
settings.showAlert(with: ConfirmDelete())
```

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

- **SwiftUI** — design primitives are framework-agnostic but no `View`-style API is shipped here. A `HomerUIKitSwiftUI` companion may follow.
- **Snapshot testing** — not bundled to keep the package dependency-free at runtime.
- **Auto-shadow update on bounds change** — planned for v0.4.0; today, call `updateShadowPathIfNeeded()` manually after a frame change.
- **Dark-mode border auto-refresh** — planned for v0.4.0; today, re-apply `border(_:)` in `traitCollectionDidChange(_:)`.

## Development

```bash
xcodebuild build -scheme HomerUIKit -destination 'generic/platform=iOS Simulator'
xcodebuild test  -scheme HomerUIKit -destination 'platform=iOS Simulator,name=iPhone 16'
```

`swift build` / `swift test` are not supported on macOS hosts because UIKit is iOS-only and `HomerFoundation` declares `.macOS(.v14)` — SPM cannot resolve the cross-platform constraint without UIKit available. CI runs the `xcodebuild` commands above on every push and PR.

## License

[MIT](LICENSE) © 2026 Ferhan Akkan
