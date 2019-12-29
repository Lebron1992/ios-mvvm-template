import UIKit

enum Storyboard: String {
    case YourStoryboard

    func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = UIStoryboard(name: rawValue, bundle: nil)
            .instantiateViewController(withIdentifier: VC.typeName) as? VC else {
                fatalError("Couldn't instantiate \(VC.typeName) from \(rawValue)")
        }
        return vc
    }
}
