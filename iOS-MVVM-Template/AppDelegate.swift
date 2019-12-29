import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let viewModel: AppDelegateViewModelType = AppDelegateViewModel()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let restoredEnv = AppEnvironment.environmentFormStorage()
        AppEnvironment.replaceCurrentEnvironment(restoredEnv)

        #if DEBUG
        if Secrets.isMockService {
            AppEnvironment.replaceCurrentEnvironment(apiService: MockService())
        }
        #endif

        UIViewController.doBadSwizzleStuff()
        UNUserNotificationCenter.current().delegate = self

        bindViewModel()
        viewModel.inputs.applicationDidFinishLaunching(
            application: application,
            launchOptions: launchOptions
        )

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        viewModel.inputs.applicationWillEnterForeground()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        viewModel.inputs.applicationDidBecomeActive()
    }

    // MARK: - Remote Notification

    func application(
        _: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("🔴 Failed to register for remote notifications: \(error.localizedDescription)")
    }

}

// MARK: - Bind View Model
extension AppDelegate {
    private func bindViewModel() {
        viewModel.outputs.pushTokenRegistrationRequestStarted
            .observeForUI()
            .observeValues {
                print("📲 [Push Registration] Push token registration started 🚀")
        }

        viewModel.outputs.pushTokenSuccessfullyGenerated
            .observeForUI()
            .observeValues { token in
                print("📲 [Push Registration] Push token successfully generated (\(token)) ✨")
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completion: @escaping () -> Void
    ) {
        viewModel.inputs.didReceiveRemoteNotification(response.notification)
        completion()
    }
}

// MARK: - Style App
extension AppDelegate {
    private func styleApp() {
        let navigationBar = UINavigationBar
            .appearance(whenContainedInInstancesOf: [UINavigationController.self])
        navigationBar.barTintColor = .appBackgroundColor
        navigationBar.isTranslucent = false
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white as Any,
            .font: UIFont.SFProText(style: .regular, size: 18)  as Any
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
    }
}
