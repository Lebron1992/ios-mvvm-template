import UIKit

private func swizzle(_ vc: UIViewController.Type) {
    [(#selector(vc.viewDidLoad), #selector(vc.custom_ViewDidLoad))]
        .forEach { (original, swizzled) in
            guard let originalMethod = class_getInstanceMethod(vc, original),
                let swizzledMethod = class_getInstanceMethod(vc, swizzled) else {
                    return
            }

            let didAddViewDidLoadMethod = class_addMethod(
                vc,
                original,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod)
            )
            if didAddViewDidLoadMethod {
                class_replaceMethod(
                    vc,
                    swizzled, method_getImplementation(originalMethod),
                    method_getTypeEncoding(originalMethod)
                )
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
    }
}

private var hasSwizzled = false

extension UIViewController {
    static func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }

        hasSwizzled = true
        swizzle(self)
    }

    @objc internal func custom_ViewDidLoad() {
        custom_ViewDidLoad()
        bindViewModel()
    }

    /// The entry point to bind all view model outputs. Called just before `viewDidLoad`.
    @objc func bindViewModel() {

    }
}
