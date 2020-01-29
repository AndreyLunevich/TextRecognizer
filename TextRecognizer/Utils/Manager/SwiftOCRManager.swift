import UIKit
import SwiftOCR

final class SwiftOCRManager: OCRManager {

    private let ocr = SwiftOCR()

    func recognize(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        ocr.recognize(image) { text in
            completion(.success(text))
        }
    }
}
