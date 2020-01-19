import UIKit

final class HistoryPresenter: FlatItemsPresenter {

    struct Item {

        let image: UIImage?
        let title: String

        init(recognition: Recognition) {
            image = UIImage(contentsOfFile: PathBuilder.image(named: recognition.imageName).path)
            title = recognition.text ?? "-"
        }
    }

    var display: (() -> Void)?

    private(set) var items: [Item] = []

    private let router: HistoryRouter
    private let worker: RecognitionWorker

    init(router: HistoryRouter = HistoryRouterImpl(),
         worker: RecognitionWorker = RecognitionWorker()) {
        self.router = router
        self.worker = worker
    }

    func setup(from controller: UIViewController) {
        worker.findAll { [weak self] result in
            switch result {
            case .success(let entities):
                self?.items = entities.map { Item(recognition: $0)}

                self?.display?()

            case .failure(let error):
                self?.router.presentInfoAlert(from: controller, title: "", message: error.localizedDescription)
            }
        }
    }
}
