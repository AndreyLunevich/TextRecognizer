import UIKit

class RecognitionWorker {

    private static let database = PathBuilder.database(named: "TextRecognizer").absoluteString

    private let database: AnyDatabase<Recognition>
    private let imageStorage: ImageStorage
    private let queue = DispatchQueue(label: "recognition.worker.queue")

    init(database: AnyDatabase<Recognition> = AnyDatabase(database: RecognitionDatabase(path: database)),
         imageStorage: ImageStorage = DiskImageStorage()) {
        self.database = database
        self.imageStorage = imageStorage
    }

    func save(image: UIImage, text: String, completion: @escaping (_ result: Result<Void, Error>) -> Void) {
        queue.async {
            do {
                let imageName = UUID().uuidString

                let recognition = Recognition(imageName: imageName, text: text)

                try self.database.save(entity: recognition)

                try self.imageStorage.save(image, url: PathBuilder.image(named: imageName))

                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func findAll(completion: @escaping (_ result: Result<[Recognition], Error>) -> Void) {
        queue.async {
            do {
                let entities = Array<Recognition>(try self.database.findAll())

                DispatchQueue.main.async {
                    completion(.success(entities))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
