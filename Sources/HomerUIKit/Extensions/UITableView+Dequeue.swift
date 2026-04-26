import UIKit

@MainActor
public extension UITableView {

    /// Registers a `UITableViewCell` subclass using its runtime
    /// type name (`T.description()`) as the reuse identifier.
    ///
    /// - Parameter cellClass: The cell class to register.
    func register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: T.description())
    }

    /// Dequeues a strongly-typed cell at the given index path.
    ///
    /// The cell is looked up by its runtime type name. If dequeuing
    /// fails (typically because ``register(_:)`` was not called for
    /// `T`), this method traps with a clear diagnostic — it's a
    /// programmer error, not a runtime condition to recover from.
    ///
    /// ```swift
    /// let cell: ProductCell = tableView.dequeueReusableCell(for: indexPath)
    /// ```
    ///
    /// - Parameter indexPath: The index path the cell will be used
    ///   at.
    /// - Returns: A cell of type `T`.
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(
                withIdentifier: T.description(),
                for: indexPath
            ) as? T
        else {
            fatalError(
                "Failed to dequeue \(T.self) — did you call register(\(T.self).self) on the table view?"
            )
        }
        return cell
    }
}
