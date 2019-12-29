enum Route {
    case yourRoute

    var requestProperties: (method: RequestMethod, path: String, query: [String: Any]) {
        switch self {
        case .yourRoute:
            return (.GET, "/users/me", [:])
        }
    }
}
