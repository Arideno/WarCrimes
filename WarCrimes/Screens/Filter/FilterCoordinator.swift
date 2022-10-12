//
//  FilterCoordinator.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import UIKit
import SwiftUI
import Combine

final class FilterCoordinator: Coordinator<FilterModel?> {
    private let filterModel: FilterModel
    private let eventIds: [String]
    private let navigationController: UINavigationController

    init(filterModel: FilterModel, eventIds: [String], navigationController: UINavigationController) {
        self.filterModel = filterModel
        self.eventIds = eventIds
        self.navigationController = navigationController
    }

    override func start() -> AnyPublisher<FilterModel?, Never> {
        let viewModel = FilterViewModel(filterModel: filterModel, eventIds: eventIds)
        let viewController = UIHostingController(rootView: FilterView(viewModel: viewModel))
        presentedViewController = viewController

        navigationController.pushViewController(viewController, animated: true)

        return viewModel.routing.close
            .handleEvents(receiveOutput: { [weak navigationController] _ in
                navigationController?.popViewController(animated: true)
            })
            .eraseToAnyPublisher()
    }
}
