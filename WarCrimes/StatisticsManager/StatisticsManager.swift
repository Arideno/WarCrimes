//
//  StatisticsManager.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import Foundation

final class StatisticsManager {
    static func countStatistics(allEvents: [Event], dictionary: WarCrimesDictionary) -> Statistics {
        let eventIds: [String] = dictionary.events.filter({ !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }).map({ $0.key }).sorted()
        var eventTypeCount: [String: Int] = [:]

        for event in allEvents {
            for eventId in event.eventIds {
                guard eventIds.contains(eventId) else { continue }
                if eventTypeCount[eventId] != nil {
                    eventTypeCount[eventId]! += 1
                } else {
                    eventTypeCount[eventId] = 1
                }
            }
        }

        var filteredEventIds = eventIds.filter({ eventTypeCount[$0] != nil })
        filteredEventIds.sort(by: { eventTypeCount[$0]! > eventTypeCount[$1]! })

        let realEvents = allEvents.filter({ event in
            event.eventIds.contains(where: { eventId in
                eventIds.contains(eventId)
            }) && event.from <= event.till
        })

        return Statistics(realEvents: realEvents, allEventIds: eventIds, filteredEventIds: filteredEventIds, eventTypeCount: eventTypeCount)
    }
}

struct Statistics: Equatable {
    var realEvents: [Event]
    var allEventIds: [String]
    var filteredEventIds: [String]
    var eventTypeCount: [String: Int]
}
