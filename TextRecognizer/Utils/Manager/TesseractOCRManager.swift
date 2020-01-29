import UIKit
import TesseractOCR
import GPUImage

// Something wrong with setup.
final class TesseractOCRManager: OCRManager {

    private let operationQueue = OperationQueue()

    func recognize(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let operation = G8RecognitionOperation(language: "eng") else {
            completion(.success(""))

            return
        }

        operation.tesseract.engineMode = .tesseractOnly
        operation.tesseract.pageSegmentationMode = .autoOnly
        operation.tesseract.image = prepareImage(image)
        operation.recognitionCompleteBlock = { tesseract in
            completion(.success(tesseract?.recognizedText ?? ""))
        }

        operationQueue.addOperation(operation)
    }

    private func prepareImage(_ image: UIImage) -> UIImage {
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = 15.0

        return stillImageFilter.image(byFilteringImage: image)
    }
}
