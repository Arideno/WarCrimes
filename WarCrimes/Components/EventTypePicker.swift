//
//  EventTypePicker.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import SwiftUI

struct EventTypePicker: View {
    @StateObject private var dictionaryStorage: DictionaryStorage = .instance

    @Binding var excludedEventIds: [String]
    var eventIds: [String]

    var body: some View {
        List {
            ForEach(eventIds, id: \.self) { eventId in
                Button {
                    if excludedEventIds.contains(eventId) {
                        excludedEventIds.removeAll(where: { $0 == eventId })
                    } else {
                        excludedEventIds.append(eventId)
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                            .opacity(excludedEventIds.contains(eventId) ? 0 : 1)
                        Text(dictionaryStorage.dictionary?.events[eventId] ?? "Unknown")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct EventTypePicker_Previews: PreviewProvider {
    static var previews: some View {
        EventTypePicker(excludedEventIds: .constant([]), eventIds: ["2", "4"])
    }
}
#endif
