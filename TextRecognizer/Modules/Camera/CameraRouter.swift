import UIKit

protocol CameraRouter: AlertRouter {

    func showHistory(from controller: UIViewController)
}

extension CameraRouter {

    func showHistory(from controller: UIViewController) {
        let history = HistoryViewController()
        history.presenter = HistoryPresenter()

        controller.navigationController?.pushViewController(history, animated: true)
    }
}

final class CameraRouterImpl: CameraRouter {  }
