import Fluent
import Vapor

struct TalkCoffeeUserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routeUser = routes.grouped("api", "v1", "users")
        routeUser.get(use: list)
        routeUser.post(use: create)
        routeUser.group(":id") { item in
            item.get(use: index)
            item.patch(use: update)
            item.delete(use: delete)
        }
    }

    func list(_ req: Request) async throws -> [TalkCoffeeUser] {
        let users: [TalkCoffeeUser] = try await TalkCoffeeUser.query(on: req.db).all()
            return try users.map { user in
                try TalkCoffeeUser(
                    id: user.requireID(),
                    email: user.email,
                    username: user.username,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    age: user.age,
                    birthDate: user.birthDate,
                    createdAt: user.createdAt,
                    updatedAt: user.updatedAt
                    )
            }
    }

    struct userID: Content {
        var userID: UUID?
    }

    func index(_ req: Request) async throws -> [TalkCoffeeUser] {
        guard let userID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let user = TalkCoffeeUser.query(on: req.db).filter(\.$id == userID)            
        return try await user.all()
    }

    func create(_ req: Request) async throws -> TalkCoffeeUser {
        try await req.db.transaction { transaction in
                try TalkCoffeeUser.validate(content: req)
                let user = try req.content.decode(TalkCoffeeUser.self)
                // let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
                // app.middleware.use(file)
                // // Writes buffer to file.
                // try await req.fileio.writeFile(ByteBuffer(string: "writing image buffer"), at: "file")
                try await user.create(on: transaction)

                print("user post success")
                return user
            }
    }
    
    struct PatchUser: Decodable {
    var email: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    }

    func update(_ req: Request) async throws -> TalkCoffeeUser {
        try TalkCoffeeUser.validate(content: req)

        let patch = try req.content.decode(PatchUser.self)
        guard let user = try await TalkCoffeeUser.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
            
        if let email = patch.email {
            user.email = email
        }

        if let username = patch.username {
            user.username = username
        }

        if let firstName = patch.firstName {
            user.firstName = firstName
        }

        if let lastName = patch.lastName {
            user.lastName = lastName
        }
            
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