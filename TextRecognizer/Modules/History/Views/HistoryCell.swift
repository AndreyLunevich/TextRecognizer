import UIKit

final class HistoryCell: UITableViewCell {

    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func bind(image: UIImage?, title: String) {
        sourceImageView.image = image
        titleLabel.text = title
    }
}
