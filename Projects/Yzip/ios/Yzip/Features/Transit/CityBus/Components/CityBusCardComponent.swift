//
// CityBusCardComponent.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct CityBusCardComponent: View {
    let info: CityBusTimeInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "bus.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(info.routeName)
                        .font(.headline)
                    Text(info.stopName)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(remainingTimeText)
                    .font(.title3)
                    .bold()
                    .foregroundColor(info.minutesLeft <= 1 ? .red : .blue)
            }
            .padding(8)
            
            if info.minutesLeft <= Int(Config.busCardProgressThresholdMinutes) {
                ProgressView(
                    value: max(0, Config.busCardProgressThresholdMinutes - Double(info.minutesLeft)),
                    total: Config.busCardProgressThresholdMinutes
                )
                .accentColor(info.minutesLeft <= 1 ? .red : .blue)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
    
    private var remainingTimeText: String {
        switch info.minutesLeft {
        case 0...1:
            return info.isArriving ? "transit.arriving_soon".localized() : "transit.departing_soon".localized()
        default:
            return info.isArriving ? "transit.arriving_in"
                .localized(info.minutesLeft) : "transit.departing_in"
                .localized(info.minutesLeft)
        }
    }
}

#Preview("Departing") {
    CityBusCardComponent(info: CityBusTimeInfo(
        routeName: "30",
        stopName: "연세대학교",
        isArriving: false,
        minutesLeft: 0
    ))
}

#Preview("Arriving") {
    CityBusCardComponent(info: CityBusTimeInfo(
        routeName: "34-1",
        stopName: "연세대학교",
        isArriving: true,
        minutesLeft: 2
    ))
}
