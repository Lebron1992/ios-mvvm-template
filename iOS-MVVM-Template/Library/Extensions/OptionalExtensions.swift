import Foundation

extension Optional {
    func doIfSome(_ body: (Wrapped) -> Void) {
        if let value = self.optional {
            body(value)
        }
    }
}
