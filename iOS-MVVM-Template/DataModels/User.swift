import Foundation

struct User: Codable {
    let id: String
    let email: String
    let username: String?
    let firstName: String?
    let lastName: String?
    let avatar: String?
    let token: String?

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        email = try values.decode(String.self, forKey: .email)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

    enum CodingKeys: String, CodingKey {
        case id              = "user_id"
        case email
        case username
        case firstName       = "first_name"
        case lastName        = "last_name"
        case avatar
        case token
    }
}

// MARK: Encode & Decode
extension User {
    func encode() -> [String: Any] {
        var result: [String: Any] = [:]

        result["user_id"] = id
        result["email"] = email
        result["username"] = username
        result["first_name"] = firstName
        result["last_name"] = lastName
        result["avatar"] = avatar
        result["token"] = token

        return result
    }

    static func decode(from json: [String: Any]?) -> User? {
        do {
            guard let json = json else { return nil }
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return try Constant.jsonDecoder.decode(User.self, from: data)
        } catch {
            print("Decode user error: \(error.localizedDescription)")
            return nil
        }
    }
}
