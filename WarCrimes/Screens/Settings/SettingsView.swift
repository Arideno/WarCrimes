//
//  SettingsView.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import SwiftUI

struct SettingsView<VM>: View where VM: SettingsViewModelType {

    @StateObject var viewModel: VM

    init(viewModel: VM) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Language") {
                    Picker("", selection: $viewModel.selectedLanguage) {
                        ForEach(Language.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.close()
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
#endif
