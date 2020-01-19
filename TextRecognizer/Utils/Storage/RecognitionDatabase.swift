import SQLite

final class RecognitionDatabase: Database {

    typealias Entity = Recognition

    private let db: Connection

    init(path: String) {
        db = try! Connection(path)

        try! db.run(RecognitionEntity.table.create(ifNotExists: true, block: RecognitionEntity.create))
    }

    func save(entity: Recognition) throws {
        let insert = RecognitionEntity.table.insert(or: .replace,
                                                    RecognitionEntity.id <- entity.id,
                                                    RecognitionEntity.imageName <- entity.imageName,
                                                    RecognitionEntity.text <- entity.text)

        try db.run(insert)
    }

    func findAll() throws -> AnySequence<Recognition> {
        let entities = try db
            .prepare(RecognitionEntity.table)
            .map(RecognitionEntity.recognition)

        return AnySequence<Recognition>(entities)
    }
}

fileprivate final class RecognitionEntity {

    static let table = Table("recognitions")

    static let id = Expression<String>("id")
    static let imageName = Expression<String>("imageName")
    static let text = Expression<String?>("text")
}

extension RecognitionEntity {

    static func create(table: TableBuilder) {
        table.column(id)
        table.column(imageName)
        table.column(text)
    }

    static func recognition(_ row: Row) throws -> Recognition {
        return Recognition(id: row[id], imageName: row[imageName], text: row[text])
    }
}
