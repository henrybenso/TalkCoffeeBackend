import Fluent
import Vapor

final class TalkCoffeeUser: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String

    @Field(key: "username")
    var username: String
    
    @Field(key: "age")
    var age: Int?

    @Field(key: "birth_date")
    var birthDate: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
     
    init() { }

    init(id: UUID? = nil, email: String, username: String, age: Int?, birthDate: Date? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.email = email
        self.username = username
        self.age = age
        self.birthDate = birthDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}