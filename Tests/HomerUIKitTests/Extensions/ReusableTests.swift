import Testing
import UIKit
@testable import HomerUIKit

private final class FixtureTableCell: UITableViewCell {}
private final class FixtureCollectionCell: UICollectionViewCell {}
private final class FixtureSupplementaryView: UICollectionReusableView {}

@Suite("Reusable protocol")
struct ReusableProtocolTests {

    @Test("default reuseIdentifier matches the runtime type name")
    func defaultIdentifierIsTypeName() {
        #expect(FixtureTableCell.reuseIdentifier == "FixtureTableCell")
        #expect(FixtureCollectionCell.reuseIdentifier == "FixtureCollectionCell")
        #expect(FixtureSupplementaryView.reuseIdentifier == "FixtureSupplementaryView")
    }

    @Test("UITableViewCell conforms to Reusable")
    func tableViewCellConforms() {
        let cell = UITableViewCell()
        #expect(cell is any Reusable)
    }

    @Test("UICollectionViewCell conforms to Reusable via UICollectionReusableView")
    func collectionViewCellConforms() {
        let cell = UICollectionViewCell()
        #expect(cell is any Reusable)
    }
}
