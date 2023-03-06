import Fluent

struct CreateTalkCoffeeStore: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("stores")
            .id()
            .field("name", .string, .required)
            .field("rating", .double, .required)
            .field("hours", .dictionary) // use group
            .field("service_types", .dictionary(of: .bool), .required) // use group here
            .field("phone_number", .string)
            .field("instagram", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("stores").delete()
    }
}