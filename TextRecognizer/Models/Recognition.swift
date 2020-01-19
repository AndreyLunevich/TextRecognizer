import Foundation

final class Recognition {

    var id: String
    var imageName: String
    var text: String?

    init(id: String = UUID().uuidString, imageName: String, text: String?) {
        self.id = id
        self.imageName = imageName
        self.text = text
    }
}
