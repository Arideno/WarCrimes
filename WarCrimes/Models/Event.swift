//
//  Event.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import MapKit

struct Event: Decodable, Equatable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var from: Date
    var till: Date
    var latitude: Double?
    var longitude: Double?
    var eventIds: [String] = []
    var qualificationIds: [String] = []
    var objectStatusIds: [String] = []
    var affectedTypeIds: [String] = []
    var affectedNumbers: [Int] = []

    init(id: String, from: Date, till: Date, latitude: Double?, longitude: Double?, eventIds: [String], qualificationIds: [String], objectStatusIds: [String], affectedTypeIds: [String], affectedNumbers: [Int]) {
        self.id = id
        self.from = from
        self.till = till
        self.latitude = latitude
        self.longitude = longitude
        self.eventIds = eventIds
        self.qualificationIds = qualificationIds
        self.objectStatusIds = objectStatusIds
        self.affectedTypeIds = affectedTypeIds
        self.affectedNumbers = affectedNumbers
    }

    enum CodingKeys: String, CodingKey {
        case from
        case till
        case latitude = "lat"
        case longitude = "lon"
        case eventIds = "event"
        case qualificationIds = "qualification"
        case objectStatusIds = "object_status"
        case affectedTypeIds = "affected_type"
        case affectedNumbers = "affected_number"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.from = try container.decode(Date.self, forKey: .from)
        self.till = try container.decode(Date.self, forKey: .till)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.eventIds = try container.decodeIfPresent([String].self, forKey: .eventIds) ?? []
        self.qualificationIds = try container.decodeIfPresent([String].self, forKey: .qualificationIds) ?? []
        self.objectStatusIds = try container.decodeIfPresent([String].self, forKey: .objectStatusIds) ?? []
        self.affectedTypeIds = try container.decodeIfPresent([String].self, forKey: .affectedTypeIds) ?? []

        if let affectedNumberStringArray = try? container.decodeIfPresent([String].self, forKey: .affectedNumbers) {
            self.affectedNumbers = affectedNumberStringArray.map({ Int($0) ?? 0 })
        } else if let affectedNumberIntArray = try? container.decodeIfPresent([Int].self, forKey: .affectedNumbers) {
            self.affectedNumbers = affectedNumberIntArray
        }
    }
}
