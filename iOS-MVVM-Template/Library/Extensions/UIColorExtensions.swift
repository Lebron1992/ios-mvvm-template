import UIKit

extension UIColor {
    static func RGB(
        _ r: CGFloat,
        _ g: CGFloat,
        _ b: CGFloat,
        _ alpha: CGFloat = 1) -> UIColor {
        return UIColor(
            displayP3Red: r / 255,
            green: g / 255,
            blue: b / 255,
            alpha: alpha
        )
    }

    static func random() -> UIColor {
        let red: CGFloat = CGFloat(drand48())
        let green: CGFloat = CGFloat(drand48())
        let blue: CGFloat = CGFloat(drand48())
        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1.0
        )
    }

    static func hex(_ hexStr: String) -> UIColor {
        var cString: String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            fatalError("hexStr must be similar to `#2F2F2F` or `2F2F2F`")
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func toImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
