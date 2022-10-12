//
//  MockDataLoader.swift
//  WarCrimesTests
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import Combine
@testable import WarCrimes

final class MockDataLoader: DataLoder {
    private let data: Data

    init(data: Data) {
        self.data = data
    }

    func load() -> AnyPublisher<Data, Error> {
        return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
