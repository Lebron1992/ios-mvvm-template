import Foundation
import ReactiveSwift

struct MockService: ServiceType {
    let serverConfig: ServerConfigType
    let accessToken: AccessTokenType?

    init(serverConfig: ServerConfigType = ServerConfig.production,
         accessToken: AccessTokenType? = nil) {
        self.serverConfig = serverConfig
        self.accessToken = accessToken
    }

    func login(accessToken: AccessTokenType) -> MockService {
        return MockService(
            serverConfig: self.serverConfig,
            accessToken: accessToken
        )
    }

    func logout() -> MockService {
        return MockService(
            serverConfig: self.serverConfig,
            accessToken: nil
        )
    }
}
