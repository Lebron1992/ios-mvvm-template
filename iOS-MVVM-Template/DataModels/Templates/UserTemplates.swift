import Foundation

extension User {
    static let template: User = {
        do {
            let data = Data(userJson.utf8)
            let user = try Constant.jsonDecoder.decode(User.self, from: data)
            return user
        } catch {
            fatalError("decode userJson error: \(error.localizedDescription)")
        }
    }()

    private static let userJson = """
    {
     "token": "xxxxxxxxxxxxxxxxxxxxx",
     "user_id": "xxxxxxxxxxxxxxxxxxxxx",
     "username": "lebronjames",
     "first_name": "Lebron",
     "last_name": "James"
    }
    """
}
