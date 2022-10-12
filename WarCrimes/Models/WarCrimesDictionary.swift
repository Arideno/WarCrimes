//
//  WarCrimesDictionary.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation

struct WarCrimesDictionary: Equatable, Decodable {
    private(set) var affectedTypes: [String: String]
    private(set) var objectStatuses: [String: String]
    private(set) var events: [String: String]
    private(set) var qualifications: [String: String]

    init(affectedTypes: [String: String], objectStatuses: [String: String], events: [String: String], qualifications: [String: String]) {
        self.affectedTypes = affectedTypes
        self.objectStatuses = objectStatuses
        self.events = events
        self.qualifications = qualifications
    }

    enum CodingKeys: String, CodingKey {
        case affectedTypes = "affected_type"
        case objectStatuses = "object_status"
        case events = "event"
        case qualifications = "qualification"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.affectedTypes = try container.decode([String: String].self, forKey: .affectedTypes)
        self.objectStatuses = try container.decode([String: String].self, forKey: .objectStatuses)
        self.events = try container.decode([String: String].self, forKey: .events)
        self.qualifications = try container.decode([String: String].self, forKey: .qualifications)
    }
}
