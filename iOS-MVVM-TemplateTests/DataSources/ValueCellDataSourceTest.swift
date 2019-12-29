import XCTest
import UIKit
@testable import iOS_MVVM_Template

final class IntTableCell: UITableViewCell, ValueCell {
    var value: Int = 0
    func configureWith(value: Int) {
        self.value = value
    }
}

final class IntDataSource: ValueCellDataSource {
    override func registerClasses(tableView: UITableView?) {
        tableView?.registerCellClass(IntTableCell.self)
    }
}

final class ValueCellDataSourceTest: XCTestCase {
    private let dataSource = IntDataSource()
    private let tableView = UITableView()

    override func setUp() {
        super.setUp()

        dataSource.registerClasses(tableView: tableView)

        dataSource.appendRow(value: 1, cellClass: IntTableCell.self, toSection: 0)
        dataSource.appendRow(value: 2, cellClass: IntTableCell.self, toSection: 0)
        dataSource.set(values: [1, 2, 3], cellClass: IntTableCell.self, inSection: 2)
    }

    func testTableViewDataSourceMethods() {
        XCTAssertEqual(3, dataSource.numberOfSections(in: tableView))
        XCTAssertEqual(2, dataSource.tableView(tableView, numberOfRowsInSection: 0))
        XCTAssertEqual(0, dataSource.tableView(tableView, numberOfRowsInSection: 1))
        XCTAssertEqual(3, dataSource.tableView(tableView, numberOfRowsInSection: 2))
    }

    func testClearValues() {
        dataSource.clearValues()
        XCTAssertEqual(0, dataSource.numberOfItems())
    }

    func testClearValuesInSection() {
        dataSource.clearValues(inSection: 0)
        XCTAssertEqual(3, dataSource.numberOfSections(in: tableView))
        XCTAssertEqual(0, dataSource.tableView(tableView, numberOfRowsInSection: 0))
        XCTAssertEqual(0, dataSource.tableView(tableView, numberOfRowsInSection: 1))
        XCTAssertEqual(3, dataSource.tableView(tableView, numberOfRowsInSection: 2))
    }

    func testMoveItem() {
        dataSource.moveItem(
            value: 3,
            cellClass: IntTableCell.self,
            at: 2,
            to: 0,
            inSection: 2
        )
        // swiftlint:disable force_cast
        XCTAssertTrue(dataSource[IndexPath(item: 0, section: 2)] as! Int == 3)

        dataSource.moveItem(
            value: 3,
            cellClass: IntTableCell.self,
            at: 0,
            to: 1,
            inSection: 2
        )
        // swiftlint:disable force_cast
        XCTAssertTrue(dataSource[IndexPath(item: 1, section: 2)] as! Int == 3)

        dataSource.moveItem(
            value: 3,
            cellClass: IntTableCell.self,
            at: 1,
            to: 2,
            inSection: 2
        )
        // swiftlint:disable force_cast
        XCTAssertTrue(dataSource[IndexPath(item: 2, section: 2)] as! Int == 3)
    }

    func testSetValue() {
        XCTAssertTrue(dataSource[IndexPath(item: 1, section: 0)] as! Int == 2)
        dataSource.set(value: 3, cellClass: IntTableCell.self, atIndex: 1, inSection: 0)
        XCTAssertTrue(dataSource[IndexPath(item: 1, section: 0)] as! Int == 3)
    }
}
