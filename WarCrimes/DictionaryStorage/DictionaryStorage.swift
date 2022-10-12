//
//  DictionaryStorage.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import Foundation

final class DictionaryStorage: ObservableObject {
    static let instance = DictionaryStorage()

    @Published var currentLanguage: Language = .ukrainian {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "CURRENT_LANGUAGE")
        }
    }
    private var names: [Language: WarCrimesDictionary] = [:]

    var dictionary: WarCrimesDictionary? {
        names[currentLanguage]
    }

    private let cancelBag = CancelBag()

    private init() {
        currentLanguage = Language(rawValue: UserDefaults.standard.string(forKey: "CURRENT_LANGUAGE") ?? "") ?? .ukrainian

        let fileDataLoader = FileDataLoader(fileName: "names.json")
        JsonDataParser.parseNames(dataLoader: fileDataLoader)
            .sink(receiveCompletion: { _ in }) { names in
                self.names = names
                self.objectWillChange.send()
            }
            .store(in: cancelBag)
    }
}
