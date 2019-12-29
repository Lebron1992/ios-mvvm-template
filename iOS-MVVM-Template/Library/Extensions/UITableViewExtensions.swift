import UIKit

extension UITableView {
    func registerCellClass(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.defaultReusableId)
    }
}
