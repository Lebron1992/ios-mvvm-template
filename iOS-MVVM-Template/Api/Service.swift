import Foundation
import ReactiveSwift

struct Service: ServiceType {
    let serverConfig: ServerConfigType
    let accessToken: AccessTokenType?

    init(serverConfig: ServerConfigType = ServerConfig.production,
         accessToken: AccessTokenType? = nil) {
        self.serverConfig = serverConfig
        self.accessToken = accessToken
    }

    func login(accessToken: AccessTokenType) -> Service {
        return Service(
            serverConfig: serverConfig,
            accessToken: accessToken
        )
    }

    func logout() -> Service {
        return Service(
            serverConfig: serverConfig,
            accessToken: nil
        )
    }
}
