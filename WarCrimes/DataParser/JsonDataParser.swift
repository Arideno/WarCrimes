//
//  JsonDataParser.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import Combine

final class JsonDataParser: DataParser {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()

    static func parseNames(dataLoader: DataLoder) -> AnyPublisher<[Language: WarCrimesDictionary], Error> {
        struct DataStructure: Decodable {
            let dictionaries: [Language: WarCrimesDictionary]

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: Language.self)
                dictionaries = Dictionary(uniqueKeysWithValues: try container.allKeys.lazy.map({
                    (key: $0, value: try container.decode(WarCrimesDictionary.self, forKey: $0))
                }))
            }
        }

        return dataLoader.load()
            .flatMap { data -> AnyPublisher<[Language: WarCrimesDictionary], Error> in
                do {
                    let dictionaries = try decoder.decode(DataStructure.self, from: data).dictionaries

                    return Just(dictionaries).setFailureType(to: Error.self).eraseToAnyPublisher()
                } catch {
                    return Fail(error: JsonDataParserError.invalidJson).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    static func parseEvents(dataLoader: DataLoder) -> AnyPublisher<[Event], Error> {
        dataLoader.load()
            .flatMap { data -> AnyPublisher<[Event], Error> in
                do {
                    let eventsDict = try decoder.decode([String: Event].self, from: data)

                    let events = eventsDict.map { (id, event) -> Event in
                        var event = event
                        event.id = id
                        return event
                    }

                    return Just(events).setFailureType(to: Error.self).eraseToAnyPublisher()
                } catch {
                    return Fail(error: JsonDataParserError.invalidJson).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

enum JsonDataParserError: Error {
    case invalidJson
    case invalidSkipParam
    case unknown
}
