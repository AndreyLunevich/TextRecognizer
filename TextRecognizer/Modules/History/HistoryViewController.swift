import UIKit

final class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 300
            tableView.rowHeight = UITableView.automaticDimension
            tableView.register(HistoryCell.nib, forCellReuseIdentifier: HistoryCell.identifier)
            tableView.tableFooterView = UIView()
        }
    }

    var presenter: HistoryPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.display = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        presenter?.setup(from: self)
    }
}

extension HistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = presenter?.item(at: indexPath.row) else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(HistoryCell.self, for: indexPath)

        cell.bind(image: item.image, title: item.title)

        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
