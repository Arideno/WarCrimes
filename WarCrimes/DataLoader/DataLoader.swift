//
//  DataLoader.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import Combine

protocol DataLoder {
    func load() -> AnyPublisher<Data, Error>
}
