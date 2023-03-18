import Fluent
import Vapor

enum Store: String, Codable {
    case cafe, bar
}

final class TalkCoffeeStore: Model, Content {
    static let schema = "stores"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "rating")
    var rating: Double
    
    @Group(key: "sunday_hours")
    var sundayHours: Time
    
    @Group(key: "monday_hours")
    var mondayHours: Time

    @Group(key: "tuesday_hours")
    var tuesdayHours: Time

    @Group(key: "wednesday_hours")
    var wednesdayHours: Time

    @Group(key: "thursday_hours")
    var thursdayHours: Time

    @Group(key: "friday_hours")
    var fridayHours: Time

    @Group(key: "saturday_hours")
    var saturdayHours: Time

    @Field(key: "store_type")
    var storeType: Store

    @Group(key: "service_types")
    var serviceTypes: ServiceTypes

    @OptionalField(key: "phone_number")
    var phoneNumber: String?

    @OptionalField(key: "instagram")
    var instagram: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
     
    init() { }

    init(id: UUID? = nil, name: String, rating: Double, sundayHours: Time, mondayHours: Time, tuesdayHours: Time, wednesdayHours: Time, thursdayHours: Time, fridayHours: Time, saturdayHours: Time, storeType: Store, serviceTypes: ServiceTypes, phoneNumber: String? = nil, instagram: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.rating = rating
        self.sundayHours = sundayHours
        self.mondayHours = mondayHours
        self.tuesdayHours = tuesdayHours
        self.wednesdayHours = wednesdayHours
        self.fridayHours = fridayHours
        self.saturdayHours = saturdayHours
        self.storeType = storeType
        self.serviceTypes = serviceTypes
        self.phoneNumber = phoneNumber
        self.instagram = instagram
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

final class Time: Fields {
    @OptionalField(key: "open")
    var open: Date?

    @OptionalField(key: "close")
    var close: Date?

    init() { }
}

final class ServiceTypes: Fields {

    @Field(key: "sit_in")
    var sitIn: Bool

    @Field(key: "take_out")
    var takeOut: Bool

    @Field(key: "delivery")
    var delivery: Bool

    init() { }
}