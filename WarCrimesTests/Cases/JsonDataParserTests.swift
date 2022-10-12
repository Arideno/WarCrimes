//
//  JsonDataParserTests.swift
//  WarCrimesTests
//
//  Created by Anonymous on 30.09.2022.
//

import XCTest
import Combine
@testable import WarCrimes

final class JsonDataParserTests: XCTestCase {

    var cancelBag: CancelBag!
    var dateFormatter: DateFormatter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancelBag = CancelBag()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    override func tearDownWithError() throws {
        cancelBag = nil
        dateFormatter = nil
        try super.tearDownWithError()
    }

    func testParseDictionaries_parsesDictionaries() {
        let dataLoader = MockDataLoader(data: "{\"ua\":{\"affected_type\":{\"2\":\"Загибель людини\"},\"object_status\":{\"2\":\"Магазини, заводи та інші об’єкти бізнесу\"},\"event\":{\"5\":\"Артобстріл/бомбардування\"},\"qualification\":{\"1\":\"Пошкодження чи знищення історичних пам’яток, лікарень, релігійних споруд, закладів освіти, науки, мистецтва (стаття 8 (2) (b) (ix))\"}}}".data(using: .utf8)!)

        let expectedDictionaries: [Language: WarCrimesDictionary] = [
            .ukrainian: WarCrimesDictionary(affectedTypes: ["2": "Загибель людини"], objectStatuses: ["2": "Магазини, заводи та інші об’єкти бізнесу"], events: ["5": "Артобстріл/бомбардування"], qualifications: ["1": "Пошкодження чи знищення історичних пам’яток, лікарень, релігійних споруд, закладів освіти, науки, мистецтва (стаття 8 (2) (b) (ix))"])
        ]
        var dictionaries: [Language: WarCrimesDictionary] = [:]
        var error: Error?
        let expectation = self.expectation(description: "parse dictionaries")

        JsonDataParser.parseNames(dataLoader: dataLoader)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }

                expectation.fulfill()
            } receiveValue: { value in
                dictionaries = value
            }
            .store(in: cancelBag)

        wait(for: [expectation], timeout: 1)

        XCTAssertNil(error)
        XCTAssertEqual(dictionaries, expectedDictionaries)
    }

    func testParseEvents_parsesEvents() {
        let dataLoader = MockDataLoader(data: "{\"1\":{\"from\":\"2022-03-05\",\"till\":\"2022-03-05\",\"lat\":50.025400000000005,\"lon\":36.2193,\"event\":[\"5\"],\"qualification\":[\"1\"],\"object_status\":[\"5\"]}}".data(using: .utf8)!)

        let expectedEvents: [Event] = [
            Event(id: "1", from: dateFormatter.date(from: "2022-03-05")!, till: dateFormatter.date(from: "2022-03-05")!, latitude: 50.025400000000005, longitude: 36.2193, eventIds: ["5"], qualificationIds: ["1"], objectStatusIds: ["5"], affectedTypeIds: [], affectedNumbers: [])
        ]
        var events: [Event] = []
        var error: Error?
        let expectation = self.expectation(description: "parse events")

        JsonDataParser.parseEvents(dataLoader: dataLoader)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }

                expectation.fulfill()
            } receiveValue: { returnedEvents in
                events = returnedEvents.sorted(by: { Int($0.id)! < Int($1.id)! })
            }
            .store(in: cancelBag)

        wait(for: [expectation], timeout: 1)

        XCTAssertNil(error)
        XCTAssertEqual(events, expectedEvents)
    }
}
