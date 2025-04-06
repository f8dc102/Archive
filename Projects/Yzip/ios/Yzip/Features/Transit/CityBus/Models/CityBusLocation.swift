//
// CityBusLocation.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

struct CityBusLocation: Decodable, Identifiable {
    let id = UUID()
    
    @LosslessValueDecodable var routenm: String
    
    let vehicleno: String
    
    @LosslessValueDecodable var gpslati: Double
    @LosslessValueDecodable var gpslong: Double
    @LosslessValueDecodable var nodeord: Int
    
    let nodeid: String
    let nodenm: String
    let routetp: String
    
    private enum CodingKeys: String, CodingKey {
        case routenm, vehicleno, gpslati, gpslong, nodeord, nodeid, nodenm, routetp
    }
}
