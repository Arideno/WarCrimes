//
//  StatisticsManagerTests.swift
//  WarCrimesTests
//
//  Created by Anonymous on 02.10.2022.
//

import XCTest
@testable import WarCrimes

final class StatisticsManagerTests: XCTestCase {
    func testCountEventStatistics_countsEventStatistics() {
        let dateNow = Date()

        let allEvents: [Event] = [
            Event(id: "1", from: dateNow, till: dateNow, latitude: nil, longitude: nil, eventIds: ["2"], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: []),
            Event(id: "2", from: dateNow, till: dateNow, latitude: nil, longitude: nil, eventIds: ["2", "4"], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: []),
            Event(id: "3", from: dateNow, till: dateNow, latitude: nil, longitude: nil, eventIds: ["3"], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: []),
            Event(id: "4", from: dateNow, till: dateNow, latitude: nil, longitude: nil, eventIds: ["5"], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: [])
        ]
        let dictionary = WarCrimesDictionary(affectedTypes: [:], objectStatuses: [:], events: ["2": "Crime2", "4": "Crime4", "5": ""], qualifications: [:])
        let expectedEvents: [Event] = [
            Event(id: "1", from: dateNow, till: dateNow, latitude: nil, longitude: nil, eventIds: ["2"], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: []),
            Event(id: "2", from: dateNow, till: dateNow, latitude: nil, longitude: nil, eventIds: ["2", "4"], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: []),
        ]
        let expectedStatistics = Statistics(realEvents: expectedEvents, allEventIds: ["2", "4"], filteredEventIds: ["2", "4"], eventTypeCount: ["2": 2, "4": 1])
        let statistics = StatisticsManager.countStatistics(allEvents: allEvents, dictionary: dictionary)

        XCTAssertEqual(statistics, expectedStatistics)
    }
}
