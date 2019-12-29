import UIKit

extension UIFont {
    enum SFProTextFontStyle: String {
        case regular = "SFProText-Regular"
    }

    static func SFProText(style: SFProTextFontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
