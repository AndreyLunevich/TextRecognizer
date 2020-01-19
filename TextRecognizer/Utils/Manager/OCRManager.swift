import UIKit

protocol OCRManager {

    func recognize(_ image: UIImage, completion: @escaping (_ text: String) -> Void)
}
