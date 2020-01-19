import Foundation

final class PathBuilder {

    private static var documents: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func database(named name: String) -> URL {
        return documents
            .appendingPathComponent(name)
    }

    static func image(named name: String) -> URL {
        return documents
            .appendingPathComponent("images")
            .appendingPathComponent(name)
    }
}
