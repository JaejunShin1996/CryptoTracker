//
//  StatisticView.swift
//  CryptoTracker
//
//  Created by Jaejun Shin on 5/1/2023.
//

import SwiftUI

struct StatisticView: View {
    let stat: StatisticModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees:
                                (stat.percentageChange ?? 0) > 0 ? 0 : 180)
                    )
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption2)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) > 0 ?
                             Color.theme.green : Color.theme.red)
            .opacity((stat.percentageChange == nil ? 0.0 : 1.0))
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: StatisticModel.example1)
                .previewLayout(.sizeThatFits)
            StatisticView(stat: StatisticModel.example2)
                .previewLayout(.sizeThatFits)
            StatisticView(stat: StatisticModel.example3)
                .previewLayout(.sizeThatFits)
        }
    }
}
