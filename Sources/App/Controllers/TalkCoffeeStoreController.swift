import Fluent
import Vapor

// auth required api
struct TalkCoffeeStorePrivateController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routeStore = routes.grouped("api", "v2", "stores")
        routeStore.get(use: list)
        // routeStore.post(use: create)
        // routeStore.group(":id") { item in
        //     item.delete(use: delete)
        }
    }

    func list(_ req: Request) async throws -> [TalkCoffeeStore] {
        let stores: [TalkCoffeeStore] = try await TalkCoffeeStore.query(on: req.db).all()
            return try stores.map { store in
                try TalkCoffeeStore(
                    id: store.requireID(),
                    name: store.name,
                    rating: store.rating,
                    hours: store.hours,
                    serviceTypes: store.serviceTypes,
                    phoneNumber: store.phoneNumber,
                    instagram: store.instagram,
                    createdAt: store.createdAt,
                    updatedAt: store.updatedAt
                    )
            }
    }

    struct storeID: Content {
        var storeID: UUID?
    }

    func index(_ req: Request) async throws -> [TalkCoffeeStore] {
        guard let storeID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let store = TalkCoffeeStore.query(on: req.db).filter(\.$id == storeID)            
        return try await store.all()
    }

    func create(_ req: Request) async throws -> TalkCoffeeStore {
        try await req.db.transaction { transaction in
            //try TalkCoffeeStore.validate(content: req)
            let store = try req.content.decode(TalkCoffeeStore.self)
            // let file = FileMiddleware(publicDirectory: app.directory.publicDirectory)
            // app.middleware.use(file)
            // // Writes buffer to file.
            // try await req.fileio.writeFile(ByteBuffer(string: "writing image buffer"), at: "file")
            try await store.create(on: transaction)

            print("store post success")
            return store
        }
    }

    struct PatchStore: Decodable {
        var email: String?
        // check this notation
        var hours: [Date]?
        var serviceTypes: [String]?
        var phoneNumber: String?
        var instagram: String?
    }

    func update(_ req: Request) async throws -> TalkCoffeeStore {
        //no validations in model
        //try TalkCoffeeStore.validate(content: req)

        let patch = try req.content.decode(PatchStore.self)
        guard let store: TalkCoffeeStore = try await TalkCoffeeStore.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
            
        if let hours = patch.hours {
            store.hours = hours
        }
        
        if let serviceTypes = patch.serviceTypes {
            store.serviceTypes = serviceTypes
        }

        if let phoneNumber = patch.phoneNumber {
            store.phoneNumber = phoneNumber
        }

        if let instagram = patch.instagram {
            store.instagram = instagram
        }
            
        try await store.save(on: req.db)
        return store

        
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let store: TalkCoffeeStore = try await TalkCoffeeStore.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await store.delete(on: req.db)
        return .noContent
    }