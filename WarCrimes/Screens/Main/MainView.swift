//
//  MainView.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import SwiftUI
import MapKit

struct MainView<VM>: View where VM: MainViewModelType {

    @StateObject private var dictionaryStorage: DictionaryStorage = .instance

    @StateObject var viewModel: VM

    @State private var mapViewType: MKMapType = .standard

    private let colors: [Color] = [Color.blue, Color.yellow, Color.red, Color.green, Color.purple, Color.pink]

    init(viewModel: VM) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.filteredEvents.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if !viewModel.filteredEvents.isEmpty {
                    List(viewModel.filteredEventIds, id: \.self) { eventId in
                        HStack {
                            Text(dictionaryStorage.dictionary?.events[eventId] ?? "Unknown")

                            Spacer()

                            ZStack {
                                CircularProgressView(progress: Double(viewModel.eventTypesStatistics[eventId]!) / Double(viewModel.filteredEvents.count), color: colors[viewModel.filteredEventIds.firstIndex(of: eventId)! % colors.count])

                                Text("\(viewModel.eventTypesStatistics[eventId]!)")
                                    .font(.body)
                            }
                            .frame(width: 70, height: 70)
                        }
                    }
                    .listStyle(InsetListStyle())
                    .refreshable {
                        viewModel.loadEvents()
                    }
                } else {
                    Text("No data for provided filter")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.goToFilters()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
            .navigationTitle("Statistics")

            VStack {
                ZStack(alignment: .topLeading) {
                    MapViewUI(region: viewModel.coordinateRegion, mapViewType: mapViewType, annotations: viewModel.filteredEvents.compactMap(EventAnnotation.init), eventIdColors: Dictionary(uniqueKeysWithValues: viewModel.filteredEventIds.map({ ($0, colors[viewModel.filteredEventIds.firstIndex(of: $0)! % colors.count]) })))

                    Picker("", selection: $mapViewType) {
                        Text("Standard").tag(MKMapType.standard)
                        Text("Satellite").tag(MKMapType.satellite)
                        Text("Hybrid").tag(MKMapType.hybrid)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 300)
                }
            }
            .navigationTitle("War Crimes in Ukraine")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.goToSettings()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadEvents()
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
#endif
