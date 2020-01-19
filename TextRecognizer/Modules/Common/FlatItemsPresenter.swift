protocol FlatItemsPresenter {

    associatedtype Item

    var items: [Item] { get }

    func item(at index: Int) -> Item?
}

extension FlatItemsPresenter {

    func item(at index: Int) -> Item? {
        guard 0..<items.count ~= index else { return nil }

        return items[index]
    }
}
