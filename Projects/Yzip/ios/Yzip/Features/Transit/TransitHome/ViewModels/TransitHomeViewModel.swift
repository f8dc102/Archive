//
// TransitHomeViewModel.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

@MainActor
final class TransitViewModel: ObservableObject {
    @Published var hasShuttleBusCardView: Bool = false
    @Published var hasCityBusCardView: Bool = true
    
    // 셔틀버스 카드 데이터
    @Published var shuttlePassInfo = ShuttlePassInfo(
        routeName: "셔틀버스",
        routeId: "S1",
        origin: "연세대 정문",
        destination: "잠실역",
        scheduledDepartureDate: Date(),
        estimatedArrivalDate: Calendar.current.date(byAdding: .minute, value: 10, to: Date()) ?? Date(),
        isAvailable: true,
        seatCapacity: 40,
        reservedSeats: 20,
        isMine: true,
        qrCodeString: "SAMPLEQR",
        status: .scheduled
    )
    
    // 시내버스 카드 테스트용 데이터
    @Published var cityBusTimeInfo = CityBusTimeInfo(
        routeName: "34-1",
        stopName: "연세대학교",
        isArriving: true,
        minutesLeft: 1
    )
}
