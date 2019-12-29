import Foundation

struct AppEnvironment {

    private static var stack: [Environment] = {
        let isStaging: Bool = {
            if let isStagingStr = Bundle.main.infoDictionary?["IS_STAGING"] as? String {
                return isStagingStr == "YES"
            }
            return false
        }()
        let serverConfig: ServerConfig = isStaging ? .staging : .production
        let service = Service(serverConfig: serverConfig)
        let env = Environment(apiService: service)
        return [env]
    }()

    static var current: Environment! {
        return stack.last
    }

    // MARK: - Manage User Sessions

    static func login(token: String, user: User) {
        let accessToken = AccessToken(token: token)
        replaceCurrentEnvironment(
            apiService: current.apiService.login(accessToken: accessToken),
            currentUser: user
        )
    }

    static func logout() {
        replaceCurrentEnvironment(
            apiService: current.apiService.logout(),
            currentUser: nil
        )
    }

    static func updateCurrentUser(_ user: User) {
        replaceCurrentEnvironment(
            currentUser: user
        )
    }

    static var isUserLogin: Bool {
        return current.currentUser != nil
    }

    // MARK: - Manage Environments

    static func pushEnvironment(_ env: Environment) {
        saveEnvironment(env)
        stack.append(env)
    }

    static func popEnvironment() -> Environment? {
        let last = stack.popLast()
        let next = current ?? Environment()
        saveEnvironment(next)
        return last
    }

    static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }

    static func replaceCurrentEnvironment(
        apiService: ServiceType = AppEnvironment.current.apiService,
        currentUser: User? = AppEnvironment.current.currentUser) {
        replaceCurrentEnvironment(
            Environment(
                apiService: apiService,
                currentUser: currentUser
            )
        )
    }

    static func pushEnvironment(
        apiService: ServiceType = AppEnvironment.current.apiService,
        currentUser: User? = AppEnvironment.current.currentUser) {
        pushEnvironment(
            Environment(
                apiService: apiService,
                currentUser: currentUser
            )
        )
    }

    // MARK: Save & Restore

    static let environmentStorageKey = "com.example.AppEnvironment.current"

    static func saveEnvironment(_ env: Environment = AppEnvironment.current) {

        var data: [String: Any] = [:]

        data["apiService.accessToken.token"] = env.apiService.accessToken?.token
         data["currentUser"] = env.currentUser?.encode()

        UserDefaults.standard.set(data, forKey: environmentStorageKey)
        UserDefaults.standard.synchronize()
    }

    static func environmentFormStorage() -> Environment {
        let data = UserDefaults.standard.dictionary(forKey: environmentStorageKey) ?? [:]

        var service = current.apiService
        var currentUser: User?

        if let token = data["apiService.accessToken.token"] as? String {
            service = service.login(accessToken: AccessToken(token: token))
        }

        if service.accessToken != nil {
            currentUser = User.decode(from: data["currentUser"] as? [String: Any])
        }

        return Environment(
            apiService: service,
            currentUser: currentUser
        )
    }
}
