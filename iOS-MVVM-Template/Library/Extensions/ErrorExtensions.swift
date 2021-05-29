import Foundation

extension NSError {
    convenience init(code: Int = -1, reason: String) {
        let userInfo = [NSLocalizedDescriptionKey: reason,
                        NSLocalizedFailureReasonErrorKey: reason]
        self.init(domain: "", code: code, userInfo: userInfo)
    }

    static func error(fromCode code: Int) -> Error {
        let userInfo = [
            NSLocalizedDescriptionKey: errorReasonString(fromCode: code),
            NSLocalizedFailureReasonErrorKey: errorReasonString(fromCode: code)
        ]
        return NSError(domain: "", code: code, userInfo: userInfo)
    }

    private static func errorReasonString(fromCode code: Int) -> String {
        var errorString = ""
        if code >= 400 {
            errorString = "service unavailable"
        } else {
            errorString = "failed to connect to server"
        }
        return errorString
    }

    static var failedToDecodeJson: Error {
        return NSError(reason: "failed to decode json")
    }
}
