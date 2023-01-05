//
//  MarketDataModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 5/1/2023.
//

import Foundation

struct GlobalDataModel: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Int
    let markets: Int
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    let updatedAt: Int

    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }

    var marketCap: String {
        if let item = totalMarketCap.first(where: { (key, value) -> Bool in
            return key == "usd"
        }) {
            return "$" + item.value.formattedWithAbbreviations()
        }

        return ""
    }

    var volume: String {
        if let item = totalVolume.first(where: { (key, value) -> Bool in
            return key == "usd"
        }) {
            return "$" + item.value.formattedWithAbbreviations()
        }

        return ""
    }

    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { (key, value) -> Bool in
            return key == "btc"
        }) {
            return item.value.asPercentString()
        }

        return ""
    }
}
