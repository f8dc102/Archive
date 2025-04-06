//
// CityBusStopAnnotationComponent.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct CityBusStopAnnotationComponent: View {
    let stop: CityBusStopLocation
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: Config.busStopIconSize.width, height: Config.busStopIconSize.height)
                .foregroundColor(.blue)
            Text(stop.nodenm)
                .font(.caption2)
                .foregroundColor(.primary)
        }
    }
}
