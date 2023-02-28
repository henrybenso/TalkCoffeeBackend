import Fluent
import Vapor

final class TalkCoffeeStore: Model, Content {
    static let schema = "stores"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "rating")
    var rating: Double
    
    @Field(key: "hours") // change to separate fields
    var hours: [Date]

    @Field(key: "service_types")
    var serviceTypes: [String]

    @OptionalField(key: "phone_number")
    var phoneNumber: String?

    @OptionalField(key: "instagram")
    var instagram: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
     
    init() { }

    init(id: UUID? = nil, name: String, rating: Double, hours: [Date], serviceTypes: [String], phoneNumber: String? = nil, instagram: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.rating = rating
        self.hours = hours
        self.serviceTypes = serviceTypes
        self.phoneNumber = phoneNumber
        self.instagram = instagram
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// extension TalkCoffeeStore: Content { }