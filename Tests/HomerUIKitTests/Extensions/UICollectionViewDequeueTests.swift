import Testing
import UIKit
@testable import HomerUIKit

private final class TypedCollectionCell: UICollectionViewCell {}

private final class TypedHeaderView: UICollectionReusableView {}

private final class TypedFooterView: UICollectionReusableView {}

@MainActor
private final class CollectionSource: NSObject, UICollectionViewDataSource {
    var lastDequeued: UICollectionViewCell?
    var lastHeader: UICollectionReusableView?
    var lastFooter: UICollectionReusableView?

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TypedCollectionCell = collectionView.dequeueReusableCell(for: indexPath)
        lastDequeued = cell
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header: TypedHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                for: indexPath
            )
            lastHeader = header
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer: TypedFooterView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                for: indexPath
            )
            lastFooter = footer
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}

@Suite("UICollectionView typed dequeue")
@MainActor
struct UICollectionViewDequeueTests {

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

    @Test("supplementary register installs a header under the type name")
    func supplementaryRegisterInstallsHeader() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.headerReferenceSize = CGSize(width: 200, height: 30)
        let collection = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 200, height: 200),
            collectionViewLayout: layout
        )
        collection.register(TypedCollectionCell.self)
        collection.register(TypedHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)

        let source = CollectionSource()
        collection.dataSource = source
        collection.reloadData()
        collection.layoutIfNeeded()

        #expect(source.lastHeader is TypedHeaderView)
    }

    @Test("supplementary register installs a footer under the type name")
    func supplementaryRegisterInstallsFooter() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.footerReferenceSize = CGSize(width: 200, height: 30)
        let collection = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 200, height: 200),
            collectionViewLayout: layout
        )
        collection.register(TypedCollectionCell.self)
        collection.register(TypedFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)

        let source = CollectionSource()
        collection.dataSource = source
        collection.reloadData()
        collection.layoutIfNeeded()

        #expect(source.lastFooter is TypedFooterView)
    }
}
