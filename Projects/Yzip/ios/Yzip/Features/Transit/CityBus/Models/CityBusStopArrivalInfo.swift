//
// CityBusStopArrivalInfo.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

struct CityBusStopArrivalInfo: Codable {
    @LosslessValueDecodable var arrprevstationcnt: Int
    @LosslessValueDecodable var arrtime: Int
    
    let routeid: String
    let routeno: String
    let vehicletp: String
}
