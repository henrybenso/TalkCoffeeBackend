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

    @Field(key: "password")
    var password: String

    @OptionalField(key: "first_name")
    var firstName: String?

    @OptionalField(key: "last_name")
    var lastName: String?
    
    @Field(key: "age")
    var age: Int?

    @OptionalField(key: "birth_date")
    var birthDate: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
     
    init() { }

    init(id: UUID? = nil, email: String, username: String, password: String, firstName: String?, lastName: String?, age: Int?, birthDate: Date? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.birthDate = birthDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// extension TalkCoffeeUser: Validatable {
//     static func validations(_ validations: inout Validations) {
//         // CHECK MATH HERE
//         // vapor email validation doesn't work; use diff validator
//         // validations.add("username", as: String.self, is: !.empty && .count(3...) && .alphanumeric)
//         validations.add("username", as: String.self, is: \.username)
//         // validations.add("email", as: String.self, is: !.empty && .email)
//     }
// }