//
//  FilterModel.swift
//  WarCrimes
//
//  Created by Anonymous on 02.10.2022.
//

import Foundation

struct FilterModel {
    private static let startDate = Date(timeIntervalSince1970: 1645710368)

    var fromDate: Date?
    var tillDate: Date?
    var particularDate: Date? = FilterModel.startDate
    var excludedEventIds: [String] = []
}
