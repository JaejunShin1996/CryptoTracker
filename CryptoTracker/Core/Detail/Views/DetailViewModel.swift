//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 11/1/2023.
//

import Combine
import Foundation

class CoinDetailViewModel: ObservableObject {
    @Published var coinDetails: CoinDetailModel? = nil
    private var cancellables = Set<AnyCancellable>()

    private let coinDetailDataController: CoinDetailDataController

    init(coin: CoinModel) {
        self.coinDetailDataController = CoinDetailDataController(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailDataController.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
            }
            .store(in: &cancellables)
    }
}
