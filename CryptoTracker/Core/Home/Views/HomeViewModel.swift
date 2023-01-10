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
    @Published var sortOption: SortOptions = .rank

    private let coinDataController = CoinDataController()
    private let marketDataController = MarketDataController()
    private let portfolioDataController = PortfolioDataController()
    private var cancellables = Set<AnyCancellable>()

    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }

    init() {
        addSubcribers()
    }

    func addSubcribers() {
        // Updates all coins
        $searchText
            .combineLatest(coinDataController.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataController.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedPortfolioCoins) in
                guard let self = self else { return }
                self.allPortfolios = self.sortPortfolioCoinsIfNeeded(coins: returnedPortfolioCoins)
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

    // MARK: public

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataController.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinDataController.getCoins()
        marketDataController.getData()
        HapticManager.notification(type: .success)
    }

    // MARK: Private

    // filter all coins by text or sortoption
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

    private func filterAndSortCoins(text: String, startingCoins: [CoinModel], sortOption: SortOptions) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, startingCoins: startingCoins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }

    private func sortCoins(sort: SortOptions, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice > $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice < $1.currentPrice }
        }
    }

    // Coins to Portfolio
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

    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }

    // MaraketData
    private func mapMarketData(marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []

        guard let data = marketData else { return [] }

        let marketCap = StatisticModel(title: "Market cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "Market Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "Bitcoin dominance", value: data.btcDominance)

        let portfolioValue = portfolioCoins
                                .map({ $0.currentHoldingsValue })
                                .reduce(0, +)

        let previousValue = portfolioCoins
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
