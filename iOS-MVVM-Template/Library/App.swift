import Foundation

enum App {
    static let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    static let currentVersionDescription = "\(versionNumber ?? "")(\(buildNumber ?? ""))"
}
