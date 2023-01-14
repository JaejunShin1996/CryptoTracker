//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 14/1/2023.
//

import SwiftUI

struct SettingsView: View {
    let randomURL = URL(string: "https://www.google.com/")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com/")!

    var body: some View {
        NavigationView {
            List {
                cryptoSection
                coinGeckoSection
                applicationSection
            }
            .tint(.blue)
            .font(.headline)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkView()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    var cryptoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)

                Text("It uses 100% SwiftUI and Swift, MVVM architecture, Combine and CoreData.")
                    .font(.callout)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)

            Link("Random URL", destination: randomURL)
            Link("Random URL", destination: randomURL)
        } header: {
            Text("Crypto Tracker")
        }
    }

    var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)

                Text("It uses free API from CoinGecko server.")
                    .font(.callout)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)

            Link("CoinGecko URL", destination: coinGeckoURL)
            Link("Random URL", destination: randomURL)
        } header: {
            Text("Crypto Tracker")
        }
    }

    var applicationSection: some View {
        Section {
            Link("Random URL", destination: coinGeckoURL)
            Link("Random URL", destination: randomURL)
        } header: {
            Text("Application")
        }
    }
}
