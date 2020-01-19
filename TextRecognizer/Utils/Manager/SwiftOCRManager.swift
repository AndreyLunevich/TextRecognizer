import UIKit
import SwiftOCR

final class SwiftOCRManager: OCRManager {

    private let ocr = SwiftOCR()

    func recognize(_ image: UIImage, completion: @escaping (String) -> Void) {
        ocr.recognize(image, completion)
    }
}
