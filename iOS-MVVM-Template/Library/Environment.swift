import ReactiveSwift

struct Environment {
    let apiService: ServiceType
    let currentUser: User?

    /// A scheduler to use for all time-based RAC operators. Default value is
    /// `QueueScheduler.mainQueueScheduler`.
    let scheduler: DateScheduler

    /// A type that manages registration for push notifications.
    let pushRegistrationType: PushRegistrationType.Type

    init(
        apiService: ServiceType = Service(),
        currentUser: User? = nil,
        pushRegistrationType: PushRegistrationType.Type = PushRegistration.self,
        scheduler: DateScheduler = QueueScheduler.main
    ) {
        self.apiService = apiService
        self.currentUser = currentUser
        self.pushRegistrationType = pushRegistrationType
        self.scheduler = scheduler
    }

    // MARK: - Getters

    var environmentType: EnvironmentType {
        return apiService.serverConfig.environment
    }

    var isStaging: Bool {
        return apiService.serverConfig.environment == .staging
    }
}
