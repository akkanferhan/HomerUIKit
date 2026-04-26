import Testing
import UIKit
@testable import HomerUIKit

private final class TypedTableCell: UITableViewCell {}

@MainActor
private final class TableSource: NSObject, UITableViewDataSource {
    var lastDequeued: UITableViewCell?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TypedTableCell = tableView.dequeueReusableCell(for: indexPath)
        lastDequeued = cell
        return cell
    }
}

@Suite("UITableView typed dequeue")
@MainActor
struct UITableViewDequeueTests {

    @Test("register installs the cell under the type name as identifier")
    func registerInstallsCell() {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        table.register(TypedTableCell.self)
        let cell = table.dequeueReusableCell(withIdentifier: TypedTableCell.description())
        #expect(cell is TypedTableCell)
    }

    @Test("typed dequeue inside cellForRow returns the registered class")
    func typedDequeueReturnsRegisteredClass() {
        let source = TableSource()
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        table.register(TypedTableCell.self)
        table.dataSource = source
        table.reloadData()
        table.layoutIfNeeded()
        #expect(source.lastDequeued is TypedTableCell)
    }
}
