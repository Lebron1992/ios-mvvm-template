import JWT

protocol AccessTokenType {
    var token: String { get }
    var jwtToken: String { get }
}

func == (lhs: AccessTokenType, rhs: AccessTokenType) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs.token == rhs.token
}

func == (lhs: AccessTokenType?, rhs: AccessTokenType?) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs?.token == rhs?.token
}

struct AccessToken: AccessTokenType, Codable {
    let token: String

    init(token: String) {
        self.token = token
    }

    var jwtToken: String {
        let algorithm = JWTAlgorithmFactory.algorithm(byName: "HS256")
        let payload: [String: Any] = ["token": token]
        let jwtToken = JWT.encodePayload(
            payload,
            withSecret: Secrets.jwtSecret,
            algorithm: algorithm
            ) ?? ""
        return jwtToken
    }
}
