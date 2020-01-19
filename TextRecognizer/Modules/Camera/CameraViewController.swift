import UIKit

final class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var viewFinder: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var btnTakeImage: UIButton!

    var presenter: CameraPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarItems()

        presenter?.display = { [weak self] state in
            DispatchQueue.main.async {
                self?.progressView.isHidden = true

                switch state {
                case .captureEnabled:
                    self?.btnTakeImage.isEnabled = true

                case .captureDisabled:
                    self?.btnTakeImage.isEnabled = false

                case .processingImage:
                    self?.progressView.isHidden = false
                }
            }
        }

        presenter?.setup(from: self, on: cameraView)
    }

    @IBAction func btnTakeImagePressed(_ sender: Any) {
        presenter?.takeImage(from: self, area: viewFinder.frame)
    }

    @objc private func historyPressed() {
        presenter?.showHistory(from: self)
    }

    private func setupBarItems() {
        let history = UIBarButtonItem(title: "HISTORY", style: .plain, target: self, action: #selector(historyPressed))

        navigationItem.rightBarButtonItems = [history]
    }
}
