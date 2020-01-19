import UIKit

final class CameraPresenter {

    private let router: CameraRouter
    private let cameraManager: CameraManager

    init(router: CameraRouter = CameraRouterImpl(),
         cameraManager: CameraManager = CameraManager()) {
        self.router = router
        self.cameraManager = cameraManager
    }

    func setup(from controller: UIViewController, on view: UIView) {
        cameraManager.setup { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
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
}
