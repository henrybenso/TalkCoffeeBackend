import Vapor
import Fluent
// controller register calls
func routes(_ app: Application) throws {

    let controllers: [RouteCollection] = [
        TalkCoffeeUserController(),
        TalkCoffeeStoreController(),
        TalkCoffeeStorePrivateController()
        ]
    for controller in controllers {
        try app.register(collection: controller)
    }

    // struct User: Content {
    //     var id: UUID?
    //     var email: String
    //     var username: String
    //     var first_name: String?
    //     var last_name: String?
    //     var age: Int
    //     var birth_date: Date?
    //     var created_at: Date?
    //     var updated_at: Date?
    // }

    // struct Store: Content {
    //     var id: UUID?
    //     var updated_at: Date?
    // }

    //     struct userID: Content {
    //         var userID: UUID?
    //     }

        // users.get(":id") { req async throws -> [TalkCoffeeUser] in
        //     guard let userID = req.parameters.get("id", as: UUID.self) else {
        //         throw Abort(.badRequest)
        //     }
        //     let user = TalkCoffeeUser.query(on: req.db).filter(\.$id == userID)
            
        //     return try await user.all()
            
    //     }
        
    //     // DELETE REQUEST TO DELETE USER
    //     users.delete(":id") { req async throws -> HTTPStatus in
    //         guard let user = try await TalkCoffeeUser.find(req.parameters.get("id"), on: req.db) else {
    //             throw Abort(.notFound)
    //         }
    //         try await user.delete(on: req.db)
    //         print("Successfully deleted user")
            
    //         return HTTPStatus.ok
    //     }
    // }

    // app.group("api", "stores") {stores in 
    //     stores.get { req async throws -> [TalkCoffeeStore] in
    //         let stores: [TalkCoffeeStore] = try await TalkCoffeeStore.query(on: req.db).all()
    //         return try stores.map { store in
    //             try TalkCoffeeStore(
    //                 id: store.requireID(),
    //                 name: store.name,
    //                 rating: store.rating,
    //                 hours: store.hours,
    //                 serviceTypes: store.serviceTypes,
    //                 phoneNumber: store.phoneNumber,
    //                 instagram: store.instagram,
    //                 createdAt: store.createdAt,
    //                 updatedAt: store.updatedAt
    //                 )
    //         }
    //     }
    // }

    // let TalkCoffeeStoreController = TalkCoffeeStoreController()
    // app.get("stores", use: TalkCoffeeStoreController.list())
}
