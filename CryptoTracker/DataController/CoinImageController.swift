//
//  CoinImageController.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 31/12/2022.
//

import Combine
import SwiftUI
import Foundation

class CoinImageController {
    @Published var coinImage: UIImage? = nil
    var imageSubscription: AnyCancellable?

    init() {
        getImage()
    }

    private func getImage() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h") else { return }

        imageSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
