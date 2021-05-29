import Foundation
import ReactiveSwift
import Lebron_ReactiveExtensions

protocol AppDelegateViewModelInputs {
    /// Call when the application finishes launching.
    func applicationDidFinishLaunching(
        application: UIApplication?,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )

    /// Call when the application did become active.
    func applicationDidBecomeActive()

    /// Call when the application will enter foreground.
    func applicationWillEnterForeground()

    /// Call when receive remote notificaiton
    func didReceiveRemoteNotification(_ notification: UNNotification)
}

protocol AppDelegateViewModelOutputs {
    /// Emits when the push token registration request begins.
    var pushTokenRegistrationRequestStarted: Signal<(), Never> { get }

    /// Emits the push token that has been successfully generated.
    var pushTokenSuccessfullyGenerated: Signal<String, Never> { get }
}

protocol AppDelegateViewModelType {
    var inputs: AppDelegateViewModelInputs { get }
    var outputs: AppDelegateViewModelOutputs { get }
}

final class AppDelegateViewModel: AppDelegateViewModelType, AppDelegateViewModelInputs, AppDelegateViewModelOutputs {

    init() {
        let pushTokenRegistrationRequestStartedEvents = applicationLaunchOptionsProperty.signal.ignoreValues()
            .flatMap {
                AppEnvironment.current.pushRegistrationType
                    .register(for: [.alert, .badge, .sound])
                    .materialize()
        }

        pushTokenRegistrationRequestStarted = pushTokenRegistrationRequestStartedEvents.values().ignoreValues()

        pushTokenSuccessfullyGenerated = deviceTokenStringProperty.signal.skipNil()
    }

    private typealias ApplicationWithOptions = (
        application: UIApplication?,
        options: [UIApplication.LaunchOptionsKey: Any]?
    )
    private let applicationLaunchOptionsProperty = MutableProperty<ApplicationWithOptions?>(nil)
    func applicationDidFinishLaunching(
        application: UIApplication?,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        applicationLaunchOptionsProperty.value = (application, launchOptions)
    }

    private let applicationDidBecomeActiveProperty = MutableProperty(())
    func applicationDidBecomeActive() {
        applicationDidBecomeActiveProperty.value = ()
    }

    private let applicationWillEnterForegroundProperty = MutableProperty(())
    func applicationWillEnterForeground() {
        applicationWillEnterForegroundProperty.value = ()
    }

    let deviceTokenStringProperty = MutableProperty<String?>(nil)
    func didRegisterForRemoteNotifications(withFcmToken token: String) {
        deviceTokenStringProperty.value = token
    }

    func didReceiveRemoteNotification(_ notification: UNNotification) {

    }

    let pushTokenRegistrationRequestStarted: Signal<(), Never>
    let pushTokenSuccessfullyGenerated: Signal<String, Never>

    var inputs: AppDelegateViewModelInputs { return self }
    var outputs: AppDelegateViewModelOutputs { return self }
}
