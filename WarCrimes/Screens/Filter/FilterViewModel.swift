//
//  FilterViewModel.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import Foundation
import Combine

final class FilterViewModel: FilterViewModelType {

    // MARK: - Outputs
    @Published var filterModel: FilterModel
    @Published private(set) var eventIds: [String]

    // MARK: - Inputs
    func close() {
        routing.close.send(nil)
    }

    func save() {
        routing.close.send(filterModel)
    }

    init(filterModel: FilterModel, eventIds: [String]) {
        self.filterModel = filterModel
        self.eventIds = eventIds
    }

    let routing = Routing()

    struct Routing {
        var close = PassthroughSubject<FilterModel?, Never>()
    }
}

protocol FilterViewModelType: ObservableObject {
    var filterModel: FilterModel { get set }
    var eventIds: [String] { get }

    func close()
    func save()
}
