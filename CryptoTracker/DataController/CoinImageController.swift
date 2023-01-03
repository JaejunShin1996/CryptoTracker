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

    private let coin: CoinModel

    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }

    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }

        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] (returnedImage) in
                self?.coinImage = returnedImage
                self?.imageSubscription?.cancel()
            })
    }
}
