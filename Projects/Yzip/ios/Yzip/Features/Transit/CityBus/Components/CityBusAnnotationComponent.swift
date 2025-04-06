//
// CityBusAnnotationComponent.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct CityBusLocationAnnotationComponent: View {
    let bus: CityBusLocation
    let direction: Int
    
    var body: some View {
        VStack(spacing: 6) {
            CityBusLocationAnnotationComponentContent(bus: bus, direction: direction)
            
            Image(systemName: "bus.fill")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(.blue)
                .padding(8)
                .background(Circle().fill(Color.white))
                .overlay(Circle().stroke(Color.blue, lineWidth: 1))
                .shadow(radius: 3)
                .labelsHidden()
        }
    }
}

struct CityBusLocationAnnotationComponentContent: View {
    let bus: CityBusLocation
    let direction: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "\(direction == 0 ? "arrow.up" : "arrow.down").circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.blue)
                .padding(6)
                .background(Circle().fill(.ultraThinMaterial))
                .shadow(radius: 1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(bus.routenm)")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    
                Text(bus.nodenm)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 6, y: 3)
        )
        .frame(maxWidth: 240)
    }
}

#Preview {
    CityBusLocationAnnotationComponent(
        bus: CityBusLocation(
            routenm: "272",
            vehicleno: "Y",
            gpslati: 0,
            gpslong: 0,
            nodeord: 1,
            nodeid: "Node",
            nodenm: "Yonsei University",
            routetp: "Normal"
        ),
        direction: 0
    )
}
