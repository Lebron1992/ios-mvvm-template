import Foundation
import ReactiveSwift

protocol ServiceType {
    var serverConfig: ServerConfigType { get }
    var accessToken: AccessTokenType? { get }

    init(serverConfig: ServerConfigType, accessToken: AccessTokenType?)

    func login(accessToken: AccessTokenType) -> Self

    func logout() -> Self
}

func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs.serverConfig == rhs.serverConfig &&
        lhs.accessToken == rhs.accessToken
}

func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
    return !(lhs == rhs)
}

// MARK: - Prepare Request
extension ServiceType {
    func preparedRequest(forURL url: URL,
                         method: RequestMethod = .GET,
                         query: [String: Any] = [:]) -> URLRequest {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return preparedRequest(forRequest: request, query: query)
    }

    func preparedRequest(forRequest originalRequest: URLRequest,
                         query: [String: Any] = [:]) -> URLRequest {

        var request = originalRequest
        guard let url = request.url else {
            return originalRequest
        }

        var headers = defaultHeaders

        let method = request.httpMethod?.uppercased()
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        var queryItems = components.queryItems ?? []

        if method == "POST" || method == "PUT" {
            if request.httpBody == nil {
                headers["Content-Type"] = "application/json; charset=utf-8"
                request.httpBody = try? JSONSerialization.data(withJSONObject: query, options: [])
            }
        } else {
            queryItems.append(
                contentsOf: query
                    .flatMap(queryComponents)
                    .map(URLQueryItem.init(name:value:))
            )
        }
        components.queryItems = queryItems.sorted { $0.name < $1.name }
        request.url = components.url

        let currentHeaders = request.allHTTPHeaderFields ?? [:]
        request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(headers)

        return request
    }

    private func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((key, String(describing: value)))
        }

        return components
    }

    private var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        headers["Authorization"] = authorizationHeader
        return headers
    }

    private var authorizationHeader: String? {
        if let token = accessToken?.jwtToken {
            return "Bearer \(token)"
        }
        return nil
    }
}
