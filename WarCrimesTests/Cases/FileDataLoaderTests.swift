//
//  FileDataLoaderTests.swift
//  WarCrimesTests
//
//  Created by Anonymous on 30.09.2022.
//

import XCTest
import Combine
@testable import WarCrimes

final class FileDataLoaderTests: XCTestCase {

    var cancelBag: CancelBag!
    var fileName: String!
    var bundle: Bundle!
    var sut: FileDataLoader!

    override func setUpWithError() throws {
        try super.setUpWithError()
        fileName = "events.json"
        bundle = Bundle(for: FileDataLoaderTests.self)
        sut = FileDataLoader(fileName: fileName, in: bundle)
        cancelBag = CancelBag()
    }

    override func tearDownWithError() throws {
        fileName = nil
        bundle = nil
        sut = nil
        cancelBag = nil
        try super.tearDownWithError()
    }

    func testInit_createsDataLoader() {
        XCTAssertEqual(sut.fileName, fileName)
        XCTAssertEqual(sut.bundle, bundle)
    }

    func testLoad_loadsData() {
        let expectedData =
"""
{
    "1": {
        "from": "2022-03-05",
        "till": "2022-03-05",
        "lat": 50.025400000000005,
        "lon": 36.2193,
        "event": ["5"],
        "qualification": ["1"],
        "object_status": ["5"]
    }
}

""".data(using: .utf8)!
        var data: Data?
        var error: Error?
        let expectation = self.expectation(description: "loads data")

        sut.load()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }

                expectation.fulfill()
            } receiveValue: { value in
                data = value
            }
            .store(in: cancelBag)

        wait(for: [expectation], timeout: 1)

        XCTAssertNil(error)
        XCTAssertEqual(data, expectedData)
    }
}
