//
//  MainViewModel.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import Foundation
import Combine
import MapKit

final class MainViewModel: MainViewModelType {
    private let cancelBag = CancelBag()

    private var events: [Event] = [] {
        didSet {
            refilterSubject.send(self.filterModel)
        }
    }
    private var refilterSubject = PassthroughSubject<FilterModel, Never>()

    private let fileLoader = FileDataLoader(fileName: "event.json")

    // MARK: - Outputs
    @Published private(set) var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @Published private(set) var eventTypesStatistics: [String: Int] = [:]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var filteredEvents: [Event] = []
    @Published private(set) var filterModel: FilterModel = FilterModel()
    @Published private(set) var filteredEventIds: [String] = []
    private(set) var eventIds: [String] = []

    // MARK: - Inputs
    func goToSettings() {
        routing.settings.send()
    }

    func goToFilters() {
        routing.filters.send((filterModel: filterModel, eventIds: eventIds))
    }

    func loadEvents() {
        isLoading = true
        JsonDataParser.parseEvents(dataLoader: fileLoader)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { completion in
                self.isLoading = false
            } receiveValue: { events in
                self.events = events
            }
            .store(in: cancelBag)
    }

    let routing = Routing()
    let output = Output()

    struct Routing {
        var settings = PassthroughSubject<Void, Never>()
        var filters = PassthroughSubject<(filterModel: FilterModel, eventIds: [String]), Never>()
    }

    struct Output {
        var filters = PassthroughSubject<FilterModel, Never>()
    }

    init() {
        refilterSubject
            .map({ filterModel in
                self.filterEvents(self.events, filterModel: filterModel)
            })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { events in
                if let dictionary = DictionaryStorage.instance.dictionary {
                    let statistics = StatisticsManager.countStatistics(allEvents: events, dictionary: dictionary)
                    self.filteredEvents = statistics.realEvents
                    self.eventTypesStatistics = statistics.eventTypeCount
                    self.filteredEventIds = statistics.filteredEventIds
                    self.eventIds = statistics.allEventIds
                }
            })
            .store(in: cancelBag)

        $filterModel
            .sink { filterModel in
                self.refilterSubject.send(filterModel)
            }
            .store(in: cancelBag)

        output.filters
            .receive(on: DispatchQueue.main)
            .sink { filterModel in
                self.filterModel = filterModel
            }
            .store(in: cancelBag)
    }

    private func filterEvents(_ events: [Event], filterModel: FilterModel) -> [Event] {
        var filteredEvents = events

        if let particularDate = filterModel.particularDate {
            filteredEvents = filteredEvents.filter({ event in
                event.from <= particularDate && event.till >= particularDate
            })
        } else {
            if let fromDate = filterModel.fromDate {
                filteredEvents = filteredEvents.filter { event in
                    event.from >= fromDate
                }
            }

            if let tillDate = filterModel.tillDate {
                filteredEvents = filteredEvents.filter { event in
                    event.till <= tillDate
                }
            }
        }

        filteredEvents = filteredEvents.filter({ event in
            !event.eventIds.contains(where: { eventId in
                filterModel.excludedEventIds.contains(eventId)
            })
        })

        return filteredEvents
    }
}

protocol MainViewModelType: ObservableObject {
    var coordinateRegion: MKCoordinateRegion { get }
    var filteredEvents: [Event] { get }
    var eventTypesStatistics: [String: Int] { get }
    var eventIds: [String] { get }
    var filteredEventIds: [String] { get }
    var isLoading: Bool { get }
    var filterModel: FilterModel { get }

    func goToSettings()
    func goToFilters()
    func loadEvents()
}
