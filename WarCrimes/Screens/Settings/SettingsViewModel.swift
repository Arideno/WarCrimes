//
//  SettingsViewModel.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import Foundation
import Combine

final class SettingsViewModel: SettingsViewModelType {

    private let cancelBag = CancelBag()

    // MARK: - Outputs
    @Published var selectedLanguage: Language

    // MARK: - Inputs
    func close() {
        routing.close.send()
    }

    init() {
        selectedLanguage = DictionaryStorage.instance.currentLanguage

        $selectedLanguage
            .sink { language in
                DictionaryStorage.instance.currentLanguage = language
            }
            .store(in: cancelBag)
    }

    let routing = Routing()

    struct Routing {
        var close = PassthroughSubject<Void, Never>()
    }
}

protocol SettingsViewModelType: ObservableObject {
    var selectedLanguage: Language { get set }

    func close()
}
