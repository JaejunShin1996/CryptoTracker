//
//  String.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 13/1/2023.
//

import Foundation

extension String {
    var replacingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
