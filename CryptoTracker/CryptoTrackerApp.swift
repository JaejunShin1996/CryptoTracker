//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 20/12/2022.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {

    @StateObject private var vm = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .environmentObject(vm)
        }
    }
}
