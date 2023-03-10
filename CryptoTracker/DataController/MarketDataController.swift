//
//  MarketDataController.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 5/1/2023.
//

import Combine
import Foundation

class MarketDataController {
    @Published var marketData: MarketDataModel? = nil

    var markDataSubscription: AnyCancellable?

    init() {
        getData()
    }

    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

        markDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalDataModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.markDataSubscription?.cancel()
            })
    }
}
