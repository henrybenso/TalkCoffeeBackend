import Fluent

struct CreateTalkCoffeeUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("email", .string, .required)
            .unique(on: "email")
            .field("username", .string, .required)
            .unique(on: "username")
            .field("first_name", .string)
            .field("last_name", .string)
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