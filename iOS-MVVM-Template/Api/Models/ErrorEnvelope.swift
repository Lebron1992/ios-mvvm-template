struct ErrorEnvelopeResult: Codable {
    let error: ErrorEnvelope
}

struct ErrorEnvelope: Error {
    let code: Int
    let reason: String
    let detail: String
    let moreInfo: String

    // MARK: - Overrides

    var localizedDescription: String {
        return reason
    }
}

// MARK: Codable
extension ErrorEnvelope: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decode(Int.self, forKey: .code)
        reason = try values.decode(String.self, forKey: .reason)
        detail = try values.decode(String.self, forKey: .detail)
        moreInfo = try values.decode(String.self, forKey: .moreInfo)
    }

    enum CodingKeys: String, CodingKey {
        case code
        case reason
        case detail
        case moreInfo = "more_info"
    }
}

// MARK: - Errors
extension ErrorEnvelope {

    static let couldNotParseErrorEnvelopeJSON = ErrorEnvelope(
        code: 400,
        reason: "could not parse error envelope json",
        detail: "could not parse error envelope json",
        moreInfo: ""
    )

    static let couldNotParseJSON = ErrorEnvelope(
        code: 400,
        reason: "could not parse json",
        detail: "could not parse json",
        moreInfo: ""
    )

    static func couldNotDecodeJSON(_ error: Error) -> ErrorEnvelope {
        return ErrorEnvelope(
            code: 400,
            reason: error.localizedDescription,
            detail: error.localizedDescription,
            moreInfo: ""
        )
    }
}
