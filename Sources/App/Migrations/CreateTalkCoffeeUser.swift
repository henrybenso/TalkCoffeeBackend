import Fluent

struct CreateTalkCoffeeUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .field("username", .string, .required)
            .field("age", .int)
            .field("birth_date", .datetime)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}