import Foundation

protocol ServerConfigType {
    var apiBaseUrl: URL { get }
    var environment: EnvironmentType { get }
}

func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs.apiBaseUrl == rhs.apiBaseUrl &&
        lhs.environment == rhs.environment
}

struct ServerConfig: ServerConfigType {
    private(set) var apiBaseUrl: URL
    private(set) var environment: EnvironmentType

    static let production: ServerConfig = ServerConfig(
        apiBaseUrl: URL(string: Secrets.Api.Endpoint.production)!,
        environment: .production
    )

    static let staging: ServerConfig = ServerConfig(
        apiBaseUrl: URL(string: Secrets.Api.Endpoint.staging)!,
        environment: .staging
    )

    init(apiBaseUrl: URL,
         environment: EnvironmentType = .production) {
        self.apiBaseUrl = apiBaseUrl
        self.environment = environment
    }

    static func config(for environment: EnvironmentType) -> ServerConfigType {
        switch environment {
        case .production:
            return ServerConfig.production
        case .staging:
            return ServerConfig.staging
        }
    }
}
