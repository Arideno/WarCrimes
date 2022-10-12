//
//  AnnotationCalloutView.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import SwiftUI

struct AnnotationCalloutView: View {
    @StateObject private var dictionaryStorage: DictionaryStorage = .instance

    var event: Event

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(event.eventIds, id: \.self) { eventId in
                    if let eventName = dictionaryStorage.dictionary?.events[eventId] {
                        Text(eventName)
                            .font(.title2)
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                if event.objectStatusIds.contains(where: { dictionaryStorage.dictionary?.objectStatuses[$0] != nil && !(dictionaryStorage.dictionary?.objectStatuses.isEmpty ?? true) }) {
                    Text("Objects:")
                        .font(.title3)
                        .bold()
                    
                    ForEach(0..<event.objectStatusIds.count, id: \.self) { objectStatusIndex in
                        if let objectStatus = dictionaryStorage.dictionary?.objectStatuses[event.objectStatusIds[objectStatusIndex]] {
                            Text("\(objectStatusIndex + 1). \(objectStatus)")
                                .font(.body)
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                if event.affectedTypeIds.contains(where: { dictionaryStorage.dictionary?.affectedTypes[$0] != nil && !(dictionaryStorage.dictionary?.affectedTypes[$0]?.isEmpty ?? true) }) {
                    Text("Effects:")
                        .font(.title3)
                        .bold()
                    
                    ForEach(0 ..< event.affectedTypeIds.count, id: \.self) { affectedTypeIndex in
                        if let affectedType = dictionaryStorage.dictionary?.affectedTypes[event.affectedTypeIds[affectedTypeIndex]] {
                            if affectedTypeIndex < event.affectedNumbers.count {
                                Text("\(affectedTypeIndex + 1). \(affectedType) - \(event.affectedNumbers[affectedTypeIndex])")
                                    .font(.body)
                            } else {
                                Text(affectedType)
                                    .font(.body)
                            }
                        }
                    }
                }
                
                Spacer()
                    .frame(height: 10)
                
                if event.qualificationIds.contains(where: { dictionaryStorage.dictionary?.qualifications[$0] != nil && !(dictionaryStorage.dictionary?.qualifications[$0]?.isEmpty ?? true) }) {
                    Text("Details:")
                        .font(.title3)
                        .bold()
                    
                    ForEach(0..<event.qualificationIds.count, id: \.self) { qualificationIndex in
                        if let qualification = dictionaryStorage.dictionary?.qualifications[event.qualificationIds[qualificationIndex]] {
                            Text("\(qualificationIndex + 1). \(qualification)")
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }
}

#if DEBUG
struct AnnotationCalloutView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationCalloutView(event: Event(id: "1", from: Date(), till: Date(), latitude: nil, longitude: nil, eventIds: [], qualificationIds: [], objectStatusIds: [], affectedTypeIds: [], affectedNumbers: []))
    }
}
#endif
