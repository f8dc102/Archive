//
// CityBusService.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

struct CityBusService {
    static func getBusLocationData(routeId: String) async throws -> [CityBusLocation] {
        let response = try await APIClient.shared.request(
            "/getBusLocation/\(routeId)",
            responseType: CityBusAPIResponse<CityBusLocation>.self
        )
        return response.items
    }
    
    static func getBusStopLocationData(routeId: String) async throws -> [CityBusStopLocation] {
        let response = try await APIClient.shared.request(
            "/getBusStopLocation/\(routeId)",
            responseType: CityBusAPIResponse<CityBusStopLocation>.self
        )
        return response.items
    }
    
    static func getBusArrivalInfo(busStopId: String) async throws -> [CityBusStopArrivalInfo] {
        let response = try await APIClient.shared.request(
            "/getBusArrivalInfo/\(busStopId)",
            responseType: CityBusAPIResponse<CityBusStopArrivalInfo>.self
        )
        return response.items
    }
}
