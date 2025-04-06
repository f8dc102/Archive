//
// TransitHomeView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI
import UIKit

struct TransitView: View {
    @StateObject private var viewModel = TransitViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Divider()
                        .padding(.horizontal)
                    
                    BannerSection(viewModel: viewModel)
                    MenuSection()
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("transit".localized())
        }
    }
}

// MARK: - Section Components

private struct BannerSection: View {
    @ObservedObject var viewModel: TransitViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.hasShuttleBusCardView {
                ShuttleBusCardComponent(info: viewModel.shuttlePassInfo)
            }
            
            if viewModel.hasCityBusCardView {
                CityBusCardComponent(info: viewModel.cityBusTimeInfo)
            }
        }
    }
}

private struct MenuSection: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            NavigationLink(
                destination: CityBusMapView()
            ) {
                MenuCardComponent(title: "transit.citybus.map".localized(), icon: "map", subtitle: "노선별 실시간 위치 확인")
            }
            .tint(.primary)
            
            MenuCardComponent(title: "셔틀버스 정보", icon: "bus", subtitle: "시간표 및 노선 보기")
            
            MenuCardComponent(title: "실시간 정류장 정보", icon: "clock.arrow.circlepath", subtitle: "도착 정보 보기")
            
            MenuCardComponent(title: "실시간 열차 도착", icon: "train.side.front.car", subtitle: "인근역 도착 확인")
        }
    }
}

#Preview {
    TransitView()
}
