//
//  FilterView.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import SwiftUI

struct FilterView<VM>: View where VM: FilterViewModelType {
    @StateObject private var viewModel: VM

    @State private var fromDate: Date
    @State private var tillDate: Date
    @State private var particularDate: Date
    @State private var isFromDateEnabled: Bool
    @State private var isTillDateEnabled: Bool
    @State private var isParticularDateEnabled: Bool
    @State private var excludedEventIds: [String]

    init(viewModel: VM) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isFromDateEnabled = State(initialValue: viewModel.filterModel.fromDate != nil)
        self._isTillDateEnabled = State(initialValue: viewModel.filterModel.tillDate != nil)
        self._isParticularDateEnabled = State(initialValue: viewModel.filterModel.particularDate != nil)
        self._fromDate = State(initialValue: viewModel.filterModel.fromDate ?? Date())
        self._tillDate = State(initialValue: viewModel.filterModel.tillDate ?? Date())
        self._particularDate = State(initialValue: viewModel.filterModel.particularDate ?? Date())
        self._excludedEventIds = State(initialValue: viewModel.filterModel.excludedEventIds)
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Select particular date") {
                    Toggle("Enable filter", isOn: $isParticularDateEnabled)
                    DatePicker("From", selection: $particularDate, displayedComponents: .date)
                        .disabled(!isParticularDateEnabled)
                }
                Section("From date") {
                    Toggle("Enable filter", isOn: $isFromDateEnabled)
                    DatePicker("From", selection: $fromDate, displayedComponents: .date)
                        .disabled(!isFromDateEnabled)
                }
                Section("Till date") {
                    Toggle("Enable filter", isOn: $isTillDateEnabled)
                    DatePicker("Till", selection: $tillDate, displayedComponents: .date)
                        .disabled(!isTillDateEnabled)
                }
                Section("Event type") {
                    EventTypePicker(excludedEventIds: $excludedEventIds, eventIds: viewModel.eventIds)
                }
            }
            .onChange(of: fromDate) { fromDate in
                viewModel.filterModel.fromDate = isFromDateEnabled ? fromDate : nil
            }
            .onChange(of: tillDate) { tillDate in
                viewModel.filterModel.tillDate = isTillDateEnabled ? tillDate : nil
            }
            .onChange(of: particularDate) { particularDate in
                viewModel.filterModel.particularDate = isParticularDateEnabled ? particularDate : nil
            }
            .onChange(of: isFromDateEnabled) { isFromDateEnabled in
                if isFromDateEnabled {
                    viewModel.filterModel.fromDate = fromDate
                    isParticularDateEnabled = false
                } else {
                    viewModel.filterModel.fromDate = nil
                }
            }
            .onChange(of: isTillDateEnabled) { isTillDateEnabled in
                if isTillDateEnabled {
                    viewModel.filterModel.tillDate = tillDate
                    isParticularDateEnabled = false
                } else {
                    viewModel.filterModel.tillDate = nil
                }
            }
            .onChange(of: isParticularDateEnabled) { isParticularDateEnabled in
                if isParticularDateEnabled {
                    isFromDateEnabled = false
                    isTillDateEnabled = false
                    viewModel.filterModel.particularDate = particularDate
                } else {
                    viewModel.filterModel.particularDate = nil
                }
            }
            .onChange(of: excludedEventIds, perform: { excludedEventIds in
                viewModel.filterModel.excludedEventIds = excludedEventIds
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.close()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                    }
                }
            }
            .navigationTitle("Filters")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct FilterSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewModel: FilterViewModel(filterModel: .init(), eventIds: []))
    }
}
#endif

