//
//  EventAnnotation.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import Foundation
import MapKit

final class EventAnnotation: NSObject, MKAnnotation {
    let event: Event

    init?(event: Event) {
        guard event.latitude != nil && event.longitude != nil else {
            return nil
        }
        self.event = event
    }

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: event.latitude ?? 0, longitude: event.longitude ?? 0)
    }

    var subtitle: String? {
        if let eventId = event.eventIds.first {
            return DictionaryStorage.instance.dictionary?.events[eventId]
        }

        return nil
    }
}
