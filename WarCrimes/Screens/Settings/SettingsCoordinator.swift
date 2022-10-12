//
//  SettingsCoordinator.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import UIKit
import Combine
import SwiftUI

final class SettingsCoordinator: Coordinator<Void> {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = SettingsViewModel()
        let viewController = UIHostingController(rootView: SettingsView(viewModel: viewModel))
        presentedViewController = viewController

        navigationController.pushViewController(viewController, animated: true)

        return viewModel.routing.close
            .handleEvents(receiveOutput: { [weak navigationController] _ in
                navigationController?.popViewController(animated: true)
            })
            .eraseToAnyPublisher()
    }
}
