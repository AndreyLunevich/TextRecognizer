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

    private let worker: RecognitionWorker

    init(worker: RecognitionWorker = RecognitionWorker()) {
        self.worker = worker
    }

    func setup(from controller: UIViewController) {
        do {
            items = try worker
                .findAll()
                .map { Item(recognition: $0)}

            display?()
        } catch {
            // TODO show user friendly error
        }
    }
}
