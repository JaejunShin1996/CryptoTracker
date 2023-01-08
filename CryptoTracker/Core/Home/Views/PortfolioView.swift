//
//  PortfolioView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 6/1/2023.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)

                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkView()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PortfolioView()

            PortfolioView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(HomeViewModel())
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.searchText.isEmpty ? vm.allPortfolios : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedPortfolioCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 3)
                                .foregroundColor(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear)
                        )
                }
                .padding(.vertical, 4)
                .padding(.leading)
            }
        }
    }

    private func updateSelectedPortfolioCoin(coin: CoinModel) {
        selectedCoin = coin

        if let portfolioCoin = vm.allPortfolios.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }

    private var portfolioInputSection: some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text("\(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
            }

            Divider()

            HStack {
                Text("Amount holdings:")
                Spacer()
                TextField("Ex 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }

            Divider()

            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }

    private var trailingNavBarButton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)

            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ?
                1.0 : 0.0
            )

        }
        .font(.headline)
    }

    private func getCurrentValue() -> Double {
        if let currentHoldings = Double(quantityText) {
            return (selectedCoin?.currentPrice ?? 0) * currentHoldings
        }
        return 0
    }

    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else { return }

        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)

        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }

        // hide keyboard
        UIApplication.shared.endEditing()

        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
