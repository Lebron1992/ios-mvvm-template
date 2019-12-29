import UIKit

enum Nib: String {
    case YourCustomView
}

extension UITableView {
    func register(nib: Nib) {
        register(UINib(nibName: nib.rawValue, bundle: .main), forCellReuseIdentifier: nib.rawValue)
    }

    func registerHeaderFooter(nib: Nib) {
        register(UINib(nibName: nib.rawValue, bundle: .main),
                      forHeaderFooterViewReuseIdentifier: nib.rawValue)
    }
}

protocol NibLoading {
    associatedtype CustomNibType

    static func fromNib(nib: Nib) -> CustomNibType?
}

extension NibLoading {
    static func fromNib(nib: Nib) -> Self? {
        guard let view = UINib(nibName: nib.rawValue, bundle: .main)
            .instantiate(withOwner: self, options: nil)
            .first as? Self else {
                assertionFailure("Nib not found")
                return nil
        }

        return view
    }

    func view(fromNib nib: Nib) -> UIView? {
        return UINib(nibName: nib.rawValue, bundle: .main).instantiate(withOwner: self, options: nil).first
            as? UIView
    }
}
