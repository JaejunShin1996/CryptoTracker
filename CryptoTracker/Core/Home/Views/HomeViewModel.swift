//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 30/12/2022.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var allPortfolios: [CoinModel] = []

    private let dataController = CoinDataController()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubcribers()
    }

    func addSubcribers() {
        dataController.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
