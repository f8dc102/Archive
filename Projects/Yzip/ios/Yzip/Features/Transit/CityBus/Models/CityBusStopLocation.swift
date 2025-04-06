//
// CityBusStopLocation.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

struct CityBusStopLocation: Codable, Identifiable {
    @LosslessValueDecodable var gpslati: Double
    @LosslessValueDecodable var gpslong: Double
    
    let nodeid: String
    let nodenm: String
    
    @LosslessValueDecodable var nodeno: Int
    @LosslessValueDecodable var nodeord: Int
    @LosslessValueDecodable var updowncd: Int
    
    var id: String { nodeid }
}
