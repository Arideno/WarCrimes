//
//  CancelBag.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import Combine

final class CancelBag {
    fileprivate(set) var subscriptions: Set<AnyCancellable> = []

    func cancel() {
        subscriptions = []
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
