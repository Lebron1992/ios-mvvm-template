import Foundation
import ReactiveSwift
import UIKit

final class Keyboard {
    enum KeyboardStatus {
        case show
        case hide

        var isHidden: Bool {
            return self == .hide
        }
    }

    typealias Change = (
        status: KeyboardStatus,
        frame: CGRect,
        duration: TimeInterval,
        options: UIView.AnimationOptions,
        notificationName: Notification.Name
    )

    static let shared = Keyboard()
    private let (changeSignal, changeObserver) = Signal<Change, Never>.pipe()

    static var change: Signal<Change, Never> {
        return shared.changeSignal
    }

    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(change(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(change(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func change(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIView.AnimationCurve(rawValue: curveNumber.intValue)
            else {
                return
        }
        let isHidden = frame.cgRectValue.origin.y == UIScreen.main.bounds.height
        changeObserver.send(value: (
            status: isHidden ? .hide : .show,
            frame.cgRectValue,
            duration.doubleValue,
            UIView.AnimationOptions(rawValue: UInt(curve.rawValue)),
            notificationName: notification.name
        ))
    }
}
