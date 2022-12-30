//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 30/12/2022.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var allPortfolios: [CoinModel] = []

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(CoinModel.example)
            self.allPortfolios.append(CoinModel.example)
        }
    }
}
