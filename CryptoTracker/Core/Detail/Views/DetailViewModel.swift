//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 11/1/2023.
//

import Combine
import Foundation

class CoinDetailViewModel: ObservableObject {
    @Published var coin: CoinModel
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    private var cancellables = Set<AnyCancellable>()

    private let coinDetailDataController: CoinDetailDataController

    init(coin: CoinModel) {
        _coin = Published(wrappedValue: coin)
        self.coinDetailDataController = CoinDetailDataController(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailDataController.$coinDetails
            .combineLatest($coin)
            .map(mapDetailsToStatistics)
            .sink { [weak self] (returnedArray) in
                self?.overviewStatistics = returnedArray.overview
                self?.additionalStatistics = returnedArray.additional
            }
            .store(in: &cancellables)
    }

    private func mapDetailsToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        // Overview
        let overview: [StatisticModel] = overviewArray(coinModel: coinModel)

        // Additional
        let additional: [StatisticModel] = additionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)

        return (overview, additional)
    }

    private func overviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith2Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)

        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentageChange)

        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + coinModel.totalVolume.formattedWithAbbreviations()
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        return [priceStat, marketCapStat, rankStat, volumeStat]
    }

    private func additionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H.asCurrencyWith6Decimals()
        let highStat = StatisticModel(title: "24h High", value: high)

        let low = coinModel.low24H.asCurrencyWith6Decimals()
        let lowStat = StatisticModel(title: "24h Low", value: low)

        let priceChange = coinModel.priceChange24H.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentageChange)

        let marketCapChange = coinModel.marketCapChange24H.formattedWithAbbreviations()
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange)

        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
    }
}
