//
//  CoinImageView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 31/12/2022.
//

import SwiftUI

struct CoinImageView: View {
    @StateObject private var vm: CoinImageViewModel

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }

    var body: some View {
        ZStack {
            if let image = vm.coinImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: CoinModel.example)
    }
}
