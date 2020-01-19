import UIKit

protocol ImageStorage {

    func save(_ image: UIImage, url: URL) throws
}
