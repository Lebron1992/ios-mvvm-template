import UIKit

protocol ValueCell: class {
    associatedtype Value
    static var defaultReusableId: String { get }
    func configureWith(value: Value)
}

extension UITableViewCell {
    static var defaultReusableId: String {
        return description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
    }
}

extension UICollectionViewCell {
    static var defaultReusableId: String {
        return description()
            .components(separatedBy: ".")
            .dropFirst()
            .joined(separator: ".")
    }
}
