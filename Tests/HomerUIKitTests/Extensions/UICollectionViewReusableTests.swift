import Testing
import UIKit
@testable import HomerUIKit

private final class TypedCollectionCell: UICollectionViewCell {}

@MainActor
private final class CollectionSource: NSObject, UICollectionViewDataSource {
    var lastDequeued: UICollectionViewCell?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TypedCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        lastDequeued = cell
        return cell
    }
}

@Suite("UICollectionView typed dequeue")
@MainActor
struct UICollectionViewReusableTests {

    @Test("register installs the cell under the type name as identifier")
    func registerInstallsCell() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        let collection = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 200, height: 200),
            collectionViewLayout: layout
        )
        collection.register(TypedCollectionCell.self)

        let source = CollectionSource()
        collection.dataSource = source
        collection.reloadData()
        collection.layoutIfNeeded()

        #expect(source.lastDequeued is TypedCollectionCell)
    }

    @Test("typed dequeue returns the registered class via the typed overload")
    func typedDequeueReturnsRegisteredClass() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        let collection = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 200, height: 200),
            collectionViewLayout: layout
        )
        collection.register(TypedCollectionCell.self)

        let source = CollectionSource()
        collection.dataSource = source
        collection.reloadData()
        collection.layoutIfNeeded()

        let cell = source.lastDequeued
        #expect(cell != nil)
        #expect(cell is TypedCollectionCell)
    }
}
