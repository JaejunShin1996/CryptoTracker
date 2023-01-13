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
    @StateObject private var vm: CoinDetailViewModel

    @State private var showFullDescription = false

    private let columns: [GridItem] =
        [GridItem(.flexible()), GridItem(.flexible())]
    private let spacing: CGFloat = 30

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)

                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionZStack
                    overviewLazyVGrid

                    additionalTitle
                    Divider()
                    additionalLazyVGrid

                    websiteHStack
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: CoinModel.example)
        }
    }
}

extension DetailView {
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }

    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var descriptionZStack: some View {
        ZStack {
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.accent)

                    Button {
                        withAnimation(.easeOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption)
                            .bold()
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var overviewLazyVGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }

    private var additionalTitle: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var additionalLazyVGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        }
    }

    private var websiteHStack: some View {
        HStack(alignment: .firstTextBaseline, spacing: 40) {
            if let homepage = vm.homepageURL, !homepage.isEmpty,
               let url = URL(string: homepage) {
                Link("Website", destination: url)
            }

            if let reddit = vm.redditURL, !reddit.isEmpty,
               let url = URL(string: reddit) {
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
