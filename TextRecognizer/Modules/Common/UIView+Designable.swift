import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            border(width: newValue, color: borderColor)
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            border(width: borderWidth, color: newValue)
        }
        get {
            guard let cgColor = layer.borderColor else { return nil }

            return UIColor(cgColor: cgColor)
        }
    }

    func border(width: CGFloat, color: UIColor?) {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
    }
}
