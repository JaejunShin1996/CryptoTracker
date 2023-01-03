//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 31/12/2022.
//

import Combine
import UIKit
import Foundation

class CoinImageViewModel: ObservableObject {
    @Published var coinImage: UIImage? = nil
    @Published var isLoading: Bool = false

    private let coin: CoinModel
    private let coinImageDataController: CoinImageController
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        self.coinImageDataController = CoinImageController(coin: coin)
        self.isLoading = true
        addSubscribers()
    }

    private func addSubscribers() {
        coinImageDataController.$coinImage
            .sink(receiveCompletion: { [weak self] (_) in
                self?.isLoading = false
            }, receiveValue: { [weak self] (returnedImage) in
                self?.coinImage = returnedImage
            })
            .store(in: &cancellables)
    }
}
