//
//  XmarkView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 6/1/2023.
//

import SwiftUI

struct XmarkView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundColor(Color.theme.accent)
        }
    }
}

struct XmarkView_Previews: PreviewProvider {
    static var previews: some View {
        XmarkView()
    }
}
