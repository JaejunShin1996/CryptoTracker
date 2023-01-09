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
    @Published var isLoading = false

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

        $allCoins
            .combineLatest(portfolioDataController.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedPortfolioCoins) in
                self?.allPortfolios = returnedPortfolioCoins
            }
            .store(in: &cancellables)

        marketDataController.$marketData
            .combineLatest($allPortfolios)
            .map(mapMarketData)
            .sink(receiveValue: { [weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataController.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinDataController.getCoins()
        marketDataController.getData()
        HapticManager.notification(type: .success)
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

    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { (portfolio) -> Bool in
                    return portfolio.coinID == coin.id
                }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }

    private func mapMarketData(marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []

        guard let data = marketData else { return [] }

        let marketCap = StatisticModel(title: "Market cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "Market Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "Bitcoin dominance", value: data.btcDominance)

        let portfolioValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)

        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    let percentChange = coin.priceChangePercentage24H / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let portfolio = StatisticModel(
            title: "Portfolio",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])

        return stats
    }
}
