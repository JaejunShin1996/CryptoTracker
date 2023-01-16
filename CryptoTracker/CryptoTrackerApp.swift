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

    @State private var showLaunchView = true

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                }
                .environmentObject(vm)

                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading ))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
