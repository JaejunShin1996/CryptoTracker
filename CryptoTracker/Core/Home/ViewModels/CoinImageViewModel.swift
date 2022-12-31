//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 31/12/2022.
//

import UIKit
import Foundation

class CoinImageViewModel: ObservableObject {
    @Published var coinImage: UIImage? = nil
    @Published var isLoading: Bool = false

    init() {
        getCoinImage()
    }

    private func getCoinImage() {
        
    }
}
