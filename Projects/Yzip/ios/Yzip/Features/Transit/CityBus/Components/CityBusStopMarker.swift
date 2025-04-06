//
// CityBusStopMarkerComponent.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI
import MapKit

struct CityBusStopMarkerComponent: View {
    let stop: CityBusStopLocation
    
    @State private var showPopup = false
    @State private var arrivalInfo: [CityBusStopArrivalInfo] = []
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image(systemName: "mappin.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            showPopup.toggle()
                        }
                        if showPopup {
                            loadArrivalInfo()
                        }
                    }
                
                if showPopup {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("🚏 \(stop.nodenm)")
                            .font(.subheadline)
                            .bold()
                        
                        Divider()
                        
                        if isLoading {
                            Text("transit.citybus.map.fetching_arrival_data".localized())
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else if arrivalInfo.isEmpty {
                            Text(
                                "transit.citybus.map.no_approaching_bus".localized())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        } else {
                            ForEach(arrivalInfo.prefix(3), id: \.routeno) { info in
                                HStack {
                                    Text("\(info.routeno)")
                                        .bold()
                                    Spacer()
                                    Text("transit.citybus.map.busstop_count".localized(info.arrprevstationcnt))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Button(action: {
                            withAnimation { showPopup = false }
                        }) {
                            Text("common.close".localized())
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                        
                    }
                    .padding()
                    .frame(width: 200)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .offset(y: -120)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
                }
            }
        }
    }
    
    private func loadArrivalInfo() {
        isLoading = true
        Task {
            do {
                let result = try await CityBusService.getBusArrivalInfo(busStopId: stop.nodeid)
                await MainActor.run {
                    arrivalInfo = result.sorted(by: { $0.arrtime < $1.arrtime })
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    arrivalInfo = []
                    isLoading = false
                }
            }
        }
    }
}
