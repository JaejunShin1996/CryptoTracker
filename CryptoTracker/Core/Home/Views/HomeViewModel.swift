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
    
    @Published var allCoins: [CoinModel] = []
    @Published var allPortfolios: [CoinModel] = []

    private let dataController = CoinDataController()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubcribers()
    }

    func addSubcribers() {
        // Updates all coins
        $searchText
            .combineLatest(dataController.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { (text, startingCoins) -> [CoinModel] in
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
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
