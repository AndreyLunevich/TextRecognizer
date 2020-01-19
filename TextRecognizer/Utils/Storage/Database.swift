protocol Database {

    associatedtype Entity

    func save(entity: Entity) throws

    func findAll() throws -> AnySequence<Entity>
}

final class AnyDatabase<Model>: Database {

    private let _findAll: () throws -> AnySequence<Model>
    private let _save: (Model) throws -> Void

    public init<S: Database>(database: S) where S.Entity == Model {
        _findAll = database.findAll
        _save = database.save
    }

    public func findAll() throws -> AnySequence<Model> {
        return try _findAll()
    }

    public func save(entity: Model) throws {
        return try _save(entity)
    }
}
