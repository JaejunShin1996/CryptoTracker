//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 4/1/2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
