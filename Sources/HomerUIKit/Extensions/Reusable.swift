import UIKit

/// A type that exposes a stable reuse identifier.
///
/// `Reusable` is conformed to by `UITableViewCell` and
/// `UICollectionReusableView` (which covers `UICollectionViewCell`),
/// so subclasses get a sensible default identifier — the runtime
/// type name — without having to hand-write a string.
///
/// ```swift
/// final class ProductCell: UICollectionViewCell {}
/// ProductCell.reuseIdentifier  // "ProductCell"
/// ```
///
/// Override `reuseIdentifier` if you need a stable identifier across
/// renames (e.g. shipping over the wire) or when two cell types
/// share a class name in different modules.
public protocol Reusable {
    /// The reuse identifier to register and dequeue with.
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    /// Defaults to the runtime type name (e.g. `"ProductCell"`).
    static var reuseIdentifier: String { String(describing: Self.self) }
}

extension UITableViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}
