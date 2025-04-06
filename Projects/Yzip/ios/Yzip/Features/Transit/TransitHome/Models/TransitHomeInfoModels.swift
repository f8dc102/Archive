//
// TransitHomeInfoModels.swift
// Yzip
//
// Created 4/5/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

// MARK: - Shuttle Pass Model

struct ShuttlePassInfo {
    let routeName: String
    let routeId: String
    let origin: String
    let destination: String
    
    let scheduledDepartureDate: Date
    let estimatedArrivalDate: Date
    let isAvailable: Bool
    
    let seatCapacity: Int
    let reservedSeats: Int
    let isMine: Bool
    let qrCodeString: String?
    
    let status: ShuttleStatus
    
    var isFull: Bool {
        return reservedSeats >= seatCapacity
    }
    
    var remainingMinutes: Int? {
        let minutes = Calendar.current.dateComponents([.minute], from: Date(), to: estimatedArrivalDate).minute
        return (minutes != nil && minutes! >= 0) ? minutes : nil
    }
}

// MARK: - City Bus Info Models

struct CityBusTimeInfo {
    let routeName: String
    let stopName: String
    let isArriving: Bool
    let minutesLeft: UInt8
}

// MARK: - Shuttle Status Enum

enum ShuttleStatus {
    case scheduled
    case boarding
    case departed
    case completed
    case canceled
}
