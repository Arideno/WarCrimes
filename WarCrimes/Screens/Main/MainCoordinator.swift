//
//  MainCoordinator.swift
//  WarCrimes
//
//  Created by Anonymous on 01.10.2022.
//

import UIKit
import Combine
import SwiftUI

final class MainCoordinator: Coordinator<Void> {
    private let window: UIWindow

    private let cancelBag = CancelBag()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> AnyPublisher<Void, Never> {
        let viewModel = MainViewModel()
        let viewController = UIHostingController(rootView: MainView(viewModel: viewModel))
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        presentedViewController = viewController

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        viewModel.routing.settings
            .flatMap { [weak self, weak navigationController] _ -> AnyPublisher<Void, Never> in
                guard let self = self, let navigationController = navigationController else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                return self.coordinate(to: SettingsCoordinator(navigationController: navigationController))
            }
            .sink(receiveValue: { _ in })
            .store(in: cancelBag)

        viewModel.routing.filters
            .flatMap { [weak self, weak navigationController] filterModel, eventIds -> AnyPublisher<FilterModel?, Never> in
                guard let self = self, let navigationController = navigationController else { return Empty(completeImmediately: true).eraseToAnyPublisher() }
                return self.coordinate(to: FilterCoordinator(filterModel: filterModel, eventIds: eventIds, navigationController: navigationController))
            }
            .sink(receiveValue: { filterModel in
                if let filterModel = filterModel {
                    viewModel.output.filters.send(filterModel)
                }
            })
            .store(in: cancelBag)

        return Empty(completeImmediately: false).eraseToAnyPublisher()
    }
}
