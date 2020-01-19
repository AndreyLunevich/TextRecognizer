import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let camera = CameraViewController()
        camera.presenter = CameraPresenter()

        let navi = UINavigationController(rootViewController: camera)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()

        return true
    }
}
