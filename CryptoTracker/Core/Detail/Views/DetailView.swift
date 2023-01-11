//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 11/1/2023.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject var vm: CoinDetailViewModel

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }

    var body: some View {
        Text(vm.coinDetails?.name ?? "")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: CoinModel.example)
    }
}
