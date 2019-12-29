import Foundation

enum CurrentUserNotifications {
    static let sessionStarted = "CurrentUserNotifications.sessionStarted"
    static let sessionEnded = "CurrentUserNotifications.sessionEnded"
    static let currentUserUpdated = "CurrentUserNotifications.sessionUpdated"
}

extension Notification.Name {
    static let sessionStarted = Notification.Name(rawValue: CurrentUserNotifications.sessionStarted)
    static let sessionEnded = Notification.Name(rawValue: CurrentUserNotifications.sessionEnded)
    static let currentUserUpdated = Notification.Name(rawValue: CurrentUserNotifications.currentUserUpdated)
}
