import UIKit

protocol OCRManager {

    func recognize(_ image: UIImage, completion: @escaping (_ result: Result<String, Error>) -> Void)
}
