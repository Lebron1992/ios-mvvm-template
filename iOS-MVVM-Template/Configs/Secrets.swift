enum Secrets {
    static let isMockService = false
    static let jwtSecret = "YourSecret"

    enum Api {
        // swiftlint:disable nesting
        enum Endpoint {
            static let production = "https://api.example.com/api/v1"
            static let staging = "https://api-staging.example.com/api/v1"
        }
    }
}
