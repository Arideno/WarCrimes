//
//  AppDelegate.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import UIKit
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?
    var bag = Set<AnyCancellable>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        mainCoordinator = MainCoordinator(window: window!)
        mainCoordinator?.start().sink(receiveValue: {}).store(in: &bag)

        return true
    }

}
