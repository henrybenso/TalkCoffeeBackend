import Fluent
import Vapor

struct TalkCoffeeStoreController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("stores")
        users.get(use: index)
        users.post(use: create)
        users.group(":id") { item in
            item.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [TalkCoffeeStore] {
        try await TalkCoffeeStore.query(on: req.db).all()
    }

    func create(req: Request) async throws -> TalkCoffeeStore {
        let user: TalkCoffeeStore = try req.content.decode(TalkCoffeeStore.self)
        try await user.save(on: req.db)
        return user
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let store = try await TalkCoffeeStore.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await store.delete(on: req.db)
        return .noContent
    }
}