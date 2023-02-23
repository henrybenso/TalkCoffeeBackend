import Fluent
import Vapor

struct TalkCoffeeStoreController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routeStore = routes.grouped("api", "v1", "stores")
        routeStore.get(use: list)
        routeStore.get(use: search)
        routeStore.group(":id") { item in
            item.get(use: index)
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
    
    func search(_ req: Request) async throws -> [TalkCoffeeStore] {
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }

        return try await TalkCoffeeStore.query(on: req.db)
            .filter(\.$name == searchTerm)
            .all()
    }

}