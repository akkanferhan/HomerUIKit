import UIKit

@MainActor
public extension UICollectionView {

    /// Registers a `UICollectionViewCell` subclass using its runtime
    /// type name (`T.description()`) as the reuse identifier.
    ///
    /// - Parameter cellClass: The cell class to register.
    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.description())
    }

    /// Dequeues a strongly-typed cell at the given index path.
    ///
    /// The cell is looked up by its runtime type name. If dequeuing
    /// fails (typically because ``register(_:)`` was not called for
    /// `T`), this method traps with a clear diagnostic — it's a
    /// programmer error, not a runtime condition to recover from.
    ///
    /// ```swift
    /// let cell: ProductCell = collectionView.dequeueReusableCell(for: indexPath)
    /// ```
    ///
    /// - Parameter indexPath: The index path the cell will be used
    ///   at.
    /// - Returns: A cell of type `T`.
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(
                withReuseIdentifier: T.description(),
                for: indexPath
            ) as? T
        else {
            fatalError(
                "Failed to dequeue \(T.self) — did you call register(\(T.self).self) on the collection view?"
            )
        }
        return cell
    }

    /// Registers a `UICollectionReusableView` subclass as a
    /// supplementary view of the given kind, using its runtime type
    /// name (`T.description()`) as the reuse identifier.
    ///
    /// Symmetric counterpart to ``register(_:)`` for cells, so
    /// headers and footers can be installed without spelling out the
    /// identifier string twice.
    ///
    /// ```swift
    /// collectionView.register(
    ///     SectionHeader.self,
    ///     ofKind: UICollectionView.elementKindSectionHeader
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - supplementaryClass: The supplementary view class to
    ///     register.
    ///   - kind: The supplementary kind identifier
    ///     (e.g. ``UICollectionView/elementKindSectionHeader``).
    func register<T: UICollectionReusableView>(_ supplementaryClass: T.Type, ofKind kind: String) {
        register(
            supplementaryClass,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: T.description()
        )
    }

    /// Dequeues a strongly-typed supplementary view of the given kind
    /// at the given index path.
    ///
    /// The view is looked up by its runtime type name. If dequeuing
    /// fails (typically because ``register(_:ofKind:)`` was not called
    /// for `T`), this method traps with a clear diagnostic — it's a
    /// programmer error, not a runtime condition to recover from.
    ///
    /// ```swift
    /// let header: SectionHeader = collectionView.dequeueReusableSupplementaryView(
    ///     ofKind: UICollectionView.elementKindSectionHeader,
    ///     for: indexPath
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - kind: The supplementary kind identifier.
    ///   - indexPath: The index path the view will be used at.
    /// - Returns: A supplementary view of type `T`.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> T {
        guard
            let view = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: T.description(),
                for: indexPath
            ) as? T
        else {
            fatalError(
                "Failed to dequeue supplementary \(T.self) — did you call register(\(T.self).self, ofKind:) on the collection view?"
            )
        }
        return view
    }
}
