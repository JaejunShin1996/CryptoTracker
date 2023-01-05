//
//  StatisticModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 5/1/2023.
//

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?

    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }

    static let example1 = StatisticModel(title: "title", value: "value")
    static let example2 = StatisticModel(title: "title", value: "value", percentageChange: 30.0)
    static let example3 = StatisticModel(title: "title", value: "value", percentageChange: -30.0)
}
