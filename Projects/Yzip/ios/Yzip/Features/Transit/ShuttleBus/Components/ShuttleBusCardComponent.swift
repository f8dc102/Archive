//
// ShuttleBusCardComponent.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct ShuttleBusCardComponent: View {
    let info: ShuttlePassInfo
    
    // 시간 및 날짜 표시용 포맷터
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading) {
                    Text(info.routeName)
                        .font(.title2)
                        .bold()
                    Text("출발 \(timeFormatter.string(from: info.scheduledDepartureDate))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 28))
                    .foregroundColor(.blue)
            }
            
            Divider()
            
            HStack {
                Text(dateFormatter.string(from: info.scheduledDepartureDate))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if info.isAvailable {
                    if let remaining = info.remainingMinutes {
                        Text("transit.left_for_arrival".localized(remaining))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    Label("탑승 가능", systemImage: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Label("탑승 불가", systemImage: "xmark.seal.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.3), lineWidth: 0.5)
        )
    }
}

#Preview("Available") {
    ShuttleBusCardComponent(info: ShuttlePassInfo(
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
    ))
}

#Preview("Unavailable") {
    ShuttleBusCardComponent(info: ShuttlePassInfo(
        routeName: "셔틀버스",
        routeId: "S1",
        origin: "연세대 정문",
        destination: "잠실역",
        scheduledDepartureDate: Date(),
        estimatedArrivalDate: Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date(),
        isAvailable: false,
        seatCapacity: 40,
        reservedSeats: 40,
        isMine: false,
        qrCodeString: nil,
        status: .canceled
    ))
}
