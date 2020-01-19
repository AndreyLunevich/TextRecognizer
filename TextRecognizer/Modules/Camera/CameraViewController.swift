import UIKit

final class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!

    var presenter: CameraPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.setup(from: self, on: cameraView)
    }

    @IBAction func btnTakeImagePressed(_ sender: Any) {
        presenter?.takeImage(from: self)
    }
}
