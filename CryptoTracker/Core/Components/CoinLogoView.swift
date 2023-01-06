//
//  CoinLogoView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 6/1/2023.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinModel

    var body: some View {
        VStack(spacing: 5) {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)

            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogoView(coin: CoinModel.example)
                .previewLayout(.sizeThatFits)

            CoinLogoView(coin: CoinModel.example)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
