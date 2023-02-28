import Fluent

struct CreateTalkCoffeeStore: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("stores")
            .id()
            .field("name", .string)
            .field("rating", .double)
            .field("hours", .array(of: .date)) // use group
            .field("service_types", .array(of: .string)) // use group here
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