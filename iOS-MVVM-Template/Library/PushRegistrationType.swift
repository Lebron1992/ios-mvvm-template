import Foundation
import UserNotifications
import ReactiveSwift

protocol PushRegistrationType {
    static func register(for options: UNAuthorizationOptions) -> SignalProducer<Bool, Never>
    static func hasAuthorizedNotifications() -> SignalProducer<Bool, Never>
}
