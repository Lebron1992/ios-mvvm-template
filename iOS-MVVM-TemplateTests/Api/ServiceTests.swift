import XCTest
@testable import iOS_MVVM_Template

final class ServiceTests: XCTestCase {

    func testDefaults() {
        XCTAssertTrue(Service().serverConfig == ServerConfig.production)
    }

    func testEquals() {
        let s1 = Service()
        let s2 = Service(serverConfig: ServerConfig.staging)

        XCTAssertTrue(s1 == s1)
        XCTAssertTrue(s2 == s2)

        XCTAssertFalse(s1 == s2)
    }

    func testLogin() {
        let loggedOut = Service()
        let loggedIn = loggedOut.login(accessToken: AccessToken.template)

        XCTAssertTrue(loggedIn == Service(accessToken: AccessToken.template))
    }

    func testLogout() {
        let loggedIn = Service(accessToken: AccessToken.template)
        let loggedOut = loggedIn.logout()

        XCTAssertTrue(loggedOut == Service())

    }
}
