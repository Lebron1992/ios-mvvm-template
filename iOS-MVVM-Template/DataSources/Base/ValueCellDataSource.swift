import UIKit

class ValueCellDataSource: NSObject {

    private(set) var values: [[(value: Any, reusableId: String)]] = []

    // MARK: - Methods to be Overridden

    func registerClasses(tableView: UITableView?) {
    }

    func configureTableCell(_ cell: UITableViewCell, with value: Any) {
    }

    func registerClasses(collectionView: UICollectionView?) {
    }

    func configureCollectionCell(_ cell: UICollectionViewCell, with value: Any) {
    }

    // MARK: - Public Methods

    final func prependRow<Cell: ValueCell, Value: Any>(
        value: Value,
        cellClass: Cell.Type,
        toSection section: Int
    ) where Cell.Value == Value {

            padValues(forSection: section)
            values[section].insert((value, cellClass.defaultReusableId), at: 0)
    }

    final func appendRow<Cell: ValueCell, Value: Any>
        (value: Value,
         cellClass: Cell.Type,
         toSection section: Int)
        where Cell.Value == Value {

            padValues(forSection: section)
            values[section].append((value, cellClass.defaultReusableId))
    }

    final func deleteRow<Cell: ValueCell, Value: Any>(
        value: Value,
        cellClass: Cell.Type,
        atIndex index: Int,
        inSection section: Int
    ) where Cell.Value == Value {

            padValues(forSection: section)
            values[section].remove(at: index)
    }

    final func set<Cell: ValueCell, Value: Any>
        (values: [Value],
         cellClass: Cell.Type,
         inSection section: Int)
        where Cell.Value == Value {

            padValues(forSection: section)
            self.values[section] = values.map { ($0, cellClass.defaultReusableId) }
    }

    final func set<Cell: ValueCell, Value: Any>
        (value: Value,
         cellClass _: Cell.Type,
         atIndex index: Int,
         inSection section: Int
    ) where Cell.Value == Value {
        values[section][index] = (value, Cell.defaultReusableId)
    }

    final func moveItem<Cell: ValueCell, Value: Any>(
        value _: Value,
        cellClass _: Cell.Type,
        at oldIndex: Int,
        to newIndex: Int,
        inSection section: Int
    ) where Cell.Value == Value {
        var newSection = values[section]
        let removed = newSection.remove(at: oldIndex)
        newSection.insert(removed, at: newIndex)
        values[section] = newSection
    }

    final func clearValues() {
        values = [[]]
    }

    final func clearValues(inSection section: Int) {
        padValues(forSection: section)
        values[section] = []
    }

    final func numberOfItems() -> Int {
        return values.reduce(0) { accum, section in accum + section.count }
    }

    final subscript(indexPath: IndexPath) -> Any {
        return values[indexPath.section][indexPath.item].value
    }

    // MARK: - Private Methods

    private func padValues(forSection section: Int) {
        guard values.count <= section else { return }

        (values.count...section).forEach { _ in
            self.values.append([])
        }
    }
}

// MARK: - UITableViewDataSource
extension ValueCellDataSource: UITableViewDataSource {

    final func numberOfSections(in tableView: UITableView) -> Int {
        return values.count
    }

    final func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values[section].count
    }

    final func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (value, reusableId) = values[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reusableId,
            for: indexPath
        )
        configureTableCell(cell, with: value)
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension ValueCellDataSource: UICollectionViewDataSource {
    final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return values.count
    }

    final func collectionView(_ collectionView: UICollectionView,
                              numberOfItemsInSection section: Int) -> Int {
        return values[section].count
    }

    final func collectionView(_ collectionView: UICollectionView,
                              cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let (value, reusableId) = values[indexPath.section][indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reusableId,
            for: indexPath
        )
        configureCollectionCell(cell, with: value)
        return cell
    }
}
