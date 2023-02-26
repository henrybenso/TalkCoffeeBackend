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
}
