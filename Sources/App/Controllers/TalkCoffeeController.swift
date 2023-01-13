import Fluent
import Vapor

struct TalkCoffeeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.group(":id") { item in
            item.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [TalkCoffeeUser] {
        try await TalkCoffeeUser.query(on: req.db).all()
    }

    func create(req: Request) async throws -> TalkCoffeeUser {
        let user = try req.content.decode(TalkCoffeeUser.self)
        try await user.save(on: req.db)
        return user
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await TalkCoffeeUser.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .noContent
    }
}