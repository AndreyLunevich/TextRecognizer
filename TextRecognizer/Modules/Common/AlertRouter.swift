import UIKit

protocol AlertRouter {

    func presentInfoAlert(from controller: UIViewController, title: String?, message: String?, handler: (() -> Void)?)
}

extension AlertRouter {

    func presentInfoAlert(from controller: UIViewController, title: String?, message: String?, handler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            handler?()
        })

        controller.present(alert, animated: true)
    }

    // TODO: not a good way, but protocols with default implementation difficult to test :|

    func presentInfoAlert(from controller: UIViewController, title: String?, message: String?) {
        presentInfoAlert(from: controller, title: title, message: message, handler: nil)
    }
}
