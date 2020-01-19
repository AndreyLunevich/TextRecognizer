import UIKit

final class RecognitionWorker {

    private static let database = PathBuilder.database(named: "TextRecognizer").absoluteString

    private let database: AnyDatabase<Recognition>
    private let imageStorage: ImageStorage

    init(database: AnyDatabase<Recognition> = AnyDatabase(database: RecognitionStorage(path: database)),
         imageStorage: ImageStorage = DiskImageStorage()) {
        self.database = database
        self.imageStorage = imageStorage
    }

    func save(image: UIImage, text: String) throws {
        let imageName = UUID().uuidString

        let recognition = Recognition(imageName: imageName, text: text)

        try database.save(entity: recognition)

        try imageStorage.save(image, url: PathBuilder.image(named: imageName))
    }

    func findAll() throws -> [Recognition] {
        return Array<Recognition>(try database.findAll())
    }
}
