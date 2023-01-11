//
//  CoinDetailDataController.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 11/1/2023.
//

import Combine
import Foundation

class CoinDetailDataController {
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailsSubscription: AnyCancellable?
    let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }

    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }

        coinDetailsSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] (returnedCoinDetails) in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailsSubscription?.cancel()
            })
    }
}
