import UIKit

protocol AlertRouter {

    func presentInfoAlert(from controller: UIViewController, title: String?, message: String?, handler: (() -> Void)?)
}

extension AlertRouter {

    func presentInfoAlert(from controller: UIViewController,
                          title: String? = nil,
                          message: String? = nil,
                          handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { _ in
            handler?()
        })

        controller.present(alert, animated: true)
    }
}
