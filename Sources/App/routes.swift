import Vapor
import Fluent
// controller register calls
func routes(_ app: Application) throws {

    let controllers: [RouteCollection] = [
        TalkCoffeeUserController(),
        TalkCoffeeStoreController()
        ]
    for controller in controllers {
        try app.register(collection: controller)
    }

    let users = app.grouped("users")

    struct User: Content {
        var id: UUID?
        var email: String
        var username: String
        var first_name: String?
        var last_name: String?
        var age: Int
        var birth_date: Date?
        var created_at: Date?
        var updated_at: Date?
    }

    let stores = app.grouped("stores")
        struct Store: Content {
        var id: UUID?
        var updated_at: Date?
    }

    users.get { req async throws -> [TalkCoffeeUser] in
        let users = try await TalkCoffeeUser.query(on: req.db).all()
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

    users.get(":id") { req async throws -> [TalkCoffeeUser] in
        guard let userID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let user = TalkCoffeeUser.query(on: req.db).filter(\.$id == userID)
        
        return try await user.all()
        
    }
    
    users.post { req async throws -> TalkCoffeeUser in
        try await req.db.transaction { transaction in
            try TalkCoffeeUser.validate(content: req)
            let user = try req.content.decode(TalkCoffeeUser.self)
            let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
            app.middleware.use(file)
            // Writes buffer to file.
            try await req.fileio.writeFile(ByteBuffer(string: "writing image buffer"), at: "file")
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
    
    // ADD USERNAME and EMAIL VERIFICATION BEFORE CHANGE
    // PATCH REQUEST TO UPDATE USER
    users.patch(":id") { req async throws -> TalkCoffeeUser in
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
    
    // DELETE REQUEST TO DELETE USER
    users.delete(":id") { req async throws -> HTTPStatus in
        guard let user = try await TalkCoffeeUser.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        print("Successfully deleted user")
        
        return HTTPStatus.ok
    }

}
