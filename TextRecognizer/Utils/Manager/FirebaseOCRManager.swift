import Firebase

final class FirebaseOCRManager: OCRManager {

    private let vision: Vision

    init() {
        FirebaseApp.configure()

        vision = Vision.vision()
    }

    func recognize(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        vision
            .onDeviceTextRecognizer()
            .process(VisionImage(image: image)) { result, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(result?.text ?? ""))
                }
            }
    }
}
