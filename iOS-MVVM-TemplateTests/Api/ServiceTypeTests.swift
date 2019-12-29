import XCTest
@testable import iOS_MVVM_Template

final class ServiceTypeTests: XCTestCase {

    let service = Service(
        serverConfig: ServerConfig(apiBaseUrl: URL(string: "http://api.example.com")!),
        accessToken: AccessToken.template
    )

    func testEquals() {
        XCTAssertTrue(Service() != MockService())
    }

    func testPreparedRequest() {
        let url = URL(string: "http://api.example.com/v1/test?key=value")!
        let request = service.preparedRequest(forRequest: .init(url: url))

        XCTAssertEqual(["Authorization": "Bearer \(AccessToken.template.jwtToken)"], request.allHTTPHeaderFields)
    }

    func testPreparedGetURL() {
        let url = URL(string: "http://api.example.com/v1/test?key=value")!
        let request = service.preparedRequest(forURL: url, query: ["extra": "1"])

        XCTAssertEqual("http://api.example.com/v1/test?extra=1&key=value", request.url?.absoluteString)
        XCTAssertEqual("GET", request.httpMethod)
        XCTAssertEqual(["Authorization": "Bearer \(AccessToken.template.jwtToken)"], request.allHTTPHeaderFields)
    }

    func testPreparedDeleteURL() {
        let url = URL(string: "http://api.example.com/v1/test?key=value")!
        let request = service.preparedRequest(forURL: url, method: .DELETE, query: ["extra": "1"])

        XCTAssertEqual("http://api.example.com/v1/test?extra=1&key=value", request.url?.absoluteString)
        XCTAssertEqual("DELETE", request.httpMethod)
        XCTAssertEqual(["Authorization": "Bearer \(AccessToken.template.jwtToken)"], request.allHTTPHeaderFields)
    }

    func testPreparedPostURL() {
        let url = URL(string: "http://api.example.com/v1/test?key=value")!
        let request = service.preparedRequest(forURL: url, method: .POST, query: ["extra": "1"])

        XCTAssertEqual("http://api.example.com/v1/test?key=value", request.url?.absoluteString)
        XCTAssertEqual("POST", request.httpMethod)
        XCTAssertEqual([
            "Authorization": "Bearer \(AccessToken.template.jwtToken)",
            "Content-Type": "application/json; charset=utf-8"
            ], request.allHTTPHeaderFields)
        XCTAssertEqual("{\"extra\":\"1\"}", String(data: request.httpBody ?? Data(), encoding: .utf8))
    }

    func testPreparedPutURL() {
        let url = URL(string: "http://api.example.com/v1/test?key=value")!
        let request = service.preparedRequest(forURL: url, method: .PUT, query: ["extra": "1"])

        XCTAssertEqual("http://api.example.com/v1/test?key=value", request.url?.absoluteString)
        XCTAssertEqual("PUT", request.httpMethod)
        XCTAssertEqual([
            "Authorization": "Bearer \(AccessToken.template.jwtToken)",
            "Content-Type": "application/json; charset=utf-8"
            ], request.allHTTPHeaderFields)
        XCTAssertEqual("{\"extra\":\"1\"}", String(data: request.httpBody ?? Data(), encoding: .utf8))
    }
}
