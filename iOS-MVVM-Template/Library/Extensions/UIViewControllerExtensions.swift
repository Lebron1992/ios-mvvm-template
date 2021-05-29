import UIKit
import PKHUD

extension UIViewController {

    // MARK: - Type Name

    static var typeName: String {
        return String(describing: self)
    }

    // MARK: - Hide Keyboard

    func hideKeyboardWhenTappedAround(cancelTouches: Bool = false) {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(viewDidTapped)
        )
        tap.cancelsTouchesInView = cancelTouches
        view.addGestureRecognizer(tap)
    }

    @objc func viewDidTapped() {
        view.endEditing(true)
    }

    // MARK: - Navigation Items

    var backButtonItem: UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(named: "left-arrow"),
            style: .plain,
            target: self,
            action: #selector(backButtonItemTapped)
        )
        return item
    }

    @objc private func backButtonItemTapped() {
        navigationController?.popViewController(animated: true)
    }

    var closeButtonItem: UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(named: "close"),
            style: .plain,
            target: self,
            action: #selector(closeButtonItemTapped)
        )
        return item
    }

    @objc func closeButtonItemTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - HUD

    func hideHUD() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }

    func showProgress(title: String?, subtitle: String? = nil) {
        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: title, subtitle: subtitle))
        }
    }

    func showLoading() {
        DispatchQueue.main.async {
            HUD.show(.progress)
        }
    }

    // MARK: - Alert

    func alertUser(
        title: String = "",
        message: String,
        confirm: String = "Close",
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController.alert(
            title: title,
            message: message,
            confirm: confirm,
            handler: handler
        )
        customPresent(alert, animated: true)
    }
}

extension UIViewController {
    func customPresent(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if let presented = presentedViewController {
            presented.customPresent(
                viewControllerToPresent,
                animated: flag,
                completion: completion
            )
        } else {
            present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}
