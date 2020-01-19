import UIKit

protocol CellDescribable {
    static var nib: UINib? { get }
    static var identifier: String { get }
}

protocol CellBindable {
    associatedtype Item

    @discardableResult
    func bind(_ item: Item) -> Self
}

extension CellDescribable {
    
    static var nib: UINib? {
        if Bundle.main.path(forResource: String(describing: self), ofType: "nib") != nil {
            return UINib(nibName: String(describing: self), bundle: nil)
        }

        return nil
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellDescribable {  }

extension UITableViewHeaderFooterView: CellDescribable {  }

extension UICollectionViewCell: CellDescribable {  }

extension UITableView {

    typealias BindableCell = UITableViewCell & CellBindable // UITableViewCell & CellDescribable & CellBindable

    func register<T: UITableViewCell>(_ cell: T.Type) { // T: UITableViewCell & CellDescribable
        register(cell, forCellReuseIdentifier: cell.identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T { // T: UITableViewCell & CellDescribable
        return dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath)
    }

    func dequeueReusableCell<T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }

        return cell
    }

    func dequeueReusableCell<T: BindableCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath)
    }

    func dequeueReusableCell<T: BindableCell>(withIdentifier identifier: String, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }

        return cell
    }
}

extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T { // T: UICollectionViewCell & CellDescribable
        return dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withReuseIdentifier identifier: String,
                                                      for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }

        return cell
    }
}
