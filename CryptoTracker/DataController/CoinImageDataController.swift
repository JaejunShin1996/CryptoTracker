//
//  CoinImageDataController.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 31/12/2022.
//

import Combine
import SwiftUI
import Foundation

class CoinImageDataController {
    @Published var coinImage: UIImage? = nil
    var imageSubscription: AnyCancellable?

    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let imageName: String
    private let folderName = "coin_images"

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }

    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            coinImage = savedImage
            print("Retrieved from filemanager")
        } else {
            downloadCoinImage()
            print("Downloading images")
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }

        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadImage = returnedImage else { return }
                self.coinImage = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
