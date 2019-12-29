import UIKit

extension UIAlertController {
    static func alert(
        title: String? = nil,
        message: String? = nil,
        confirm: String? = nil,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: confirm ?? "OK",
                style: .cancel,
                handler: handler
            )
        )
        return alertController
    }
}
