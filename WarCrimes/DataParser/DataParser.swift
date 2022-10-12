//
//  DataParser.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import Combine

protocol DataParser {
    static func parseNames(dataLoader: DataLoder) -> AnyPublisher<[Language: WarCrimesDictionary], Error>
    static func parseEvents(dataLoader: DataLoder) -> AnyPublisher<[Event], Error>
}
