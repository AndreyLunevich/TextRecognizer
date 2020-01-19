import UIKit

protocol CameraRouter: AlertRouter {

    func showHistory(from controller: UIViewController)
}

final class CameraRouterImpl: CameraRouter {

    func showHistory(from controller: UIViewController) {
        let history = HistoryViewController()
        history.presenter = HistoryPresenter()

        controller.navigationController?.pushViewController(history, animated: true)
    }
}
