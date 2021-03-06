import UIKit

final class CameraPresenter {

    enum State {
        case processingImage
        case captureEnabled
        case captureDisabled
    }

    var display: ((_ state: State) -> Void)?

    private let router: CameraRouter
    private let cameraManager: CameraManager
    private let ocrManager: OCRManager
    private let worker: RecognitionWorker

    init(router: CameraRouter = CameraRouterImpl(),
         cameraManager: CameraManager = CameraManager(),
         ocrManager: OCRManager = FirebaseOCRManager(),
         worker: RecognitionWorker = RecognitionWorker()) {
        self.router = router
        self.cameraManager = cameraManager
        self.ocrManager = ocrManager
        self.worker = worker
    }

    func setup(from controller: UIViewController, on view: UIView) {
        display?(.captureDisabled)

        cameraManager.setup { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.display?(.captureEnabled)

                switch result {
                case .success:
                    do {
                        try self.cameraManager.start(on: view)
                    } catch {
                        self.router.presentInfoAlert(from: controller, title: "", message: error.localizedDescription)
                    }

                case .failure(let error):
                    self.router.presentInfoAlert(from: controller, title: "", message: error.localizedDescription)
                }
            }
        }
    }

    func takeImage(from controller: UIViewController, area: CGRect) {
        display?(.captureDisabled)

        cameraManager.captureImage { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let image):
                self.display?(.processingImage)

                if let normalized = image.fixedOrientation() {
                    self.ocrManager.recognize(normalized) { [weak self] result in
                        self?.display?(.captureEnabled)

                        switch result {
                        case .success(let text):
                            self?.worker.save(image: normalized, text: text) { [weak self] result in
                                switch result {
                                case .success:
                                    break

                                case .failure(let error):
                                    self?.router.presentInfoAlert(from: controller, title: "", message: error.localizedDescription)
                                }
                            }

                        case .failure(let error):
                            self?.router.presentInfoAlert(from: controller, title: "", message: error.localizedDescription)
                        }
                    }
                } else {
                    self.router.presentInfoAlert(from: controller, title: "", message: "Captured image failed")
                }

            case .failure(let error):
                self.router.presentInfoAlert(from: controller, title: "", message: error.localizedDescription)
            }
        }
    }

    func showHistory(from controller: UIViewController) {
        router.showHistory(from: controller)
    }
}
