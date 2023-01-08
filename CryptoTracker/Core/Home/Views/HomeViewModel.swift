//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 30/12/2022.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""

    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var allPortfolios: [CoinModel] = []

    private let coinDataController = CoinDataController()
    private let marketDataController = MarketDataController()
    private let portfolioDataController = PortfolioDataController()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubcribers()
    }

    func addSubcribers() {
        // Updates all coins
        $searchText
            .combineLatest(coinDataController.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)

        marketDataController.$marketData
            .map(mapMarketData)
            .sink(receiveValue: { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            })
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataController.$savedEntities)
            .map { (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { (portfolio) -> Bool in
                            return portfolio.coinID == coin.id
                        }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedPortfolioCoins) in
                self?.allPortfolios = returnedPortfolioCoins
            }
            .store(in: &cancellables)
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataController.updatePortfolio(coin: coin, amount: amount)
    }

    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startingCoins
        }

        let lowercasedText = text.lowercased()

        return startingCoins.filter { (coin) -> Bool in
            return  coin.name.contains(lowercasedText) ||
                    coin.symbol.contains(lowercasedText) ||
                    coin.id.contains(lowercasedText)
        }
    }

    private func mapMarketData(marketData: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []

        guard let data = marketData else { return [] }

        let marketCap = StatisticModel(title: "Market cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "Market Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "Bitcoin dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio", value: "", percentageChange: 0)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])

        return stats
    }
}
