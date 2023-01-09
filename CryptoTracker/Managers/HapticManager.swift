//
//  HapticManager.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 9/1/2023.
//

import SwiftUI
import Foundation

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
