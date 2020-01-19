import UIKit

final class DiskImageStorage: ImageStorage {

    private let fileManager: FileManager

    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    func save(_ image: UIImage, url: URL) throws {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }

        let parent = url.deletingLastPathComponent()

        if !fileManager.fileExists(atPath: parent.path) {
            try fileManager.createDirectory(at: parent, withIntermediateDirectories: true, attributes: nil)
        }

        try data.write(to: url, options: .atomic)
    }
}
