//
// CityBusMapViewModel.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation
import MapKit

@MainActor
final class CityBusMapViewModel: ObservableObject {
    @Published var allBusList: [CityBusLocation] = []
    @Published var isInactiveMap: [String: Bool] = [:]
    @Published var busStopsMap: [String: [CityBusStopLocation]] = [:]
    
    private var pollingTask: Task<Void, Never>?
    let allRouteInfos: [RouteInfo]
    
    init() {
        self.allRouteInfos = StaticRouteMap.routeMap.map { routeName, routeIds in
            RouteInfo(
                routeName: routeName,
                representativeRouteId: routeIds.first ?? "",
                vehicleRouteIds: routeIds
            )
        }
        
        Task {
            await initialLoad()
        }
    }
    
    deinit {
        pollingTask?.cancel()
    }
    
    // MARK: - Initial Load
    
    private func initialLoad() async {
        await fetchAllStopsIfNeeded()
        await fetchAllBusLocations()
    }
    
    // MARK: - Fetch BusStop
    
    func fetchAllStopsIfNeeded() async {
        for route in allRouteInfos {
            if busStopsMap[route.routeName] == nil {
                do {
                    let stops = try await CityBusService.getBusStopLocationData(routeId: route.representativeRouteId)
                    busStopsMap[route.routeName] = stops
                } catch {
                    DebugLogger.log("[fetchAllStopsIfNeeded] routeName: \(route.routeName) fetch failed: \(error)")
                }
            }
        }
    }
    
    func busStops(for routeName: String) -> [CityBusStopLocation] {
        busStopsMap[routeName] ?? []
    }
    
    var allStops: [CityBusStopLocation] {
        busStopsMap.values.flatMap { $0 }
    }
    
    // MARK: - BusLocation
    
    func fetchAllBusLocations() async {
        var totalBusList: [CityBusLocation] = []
        var inactiveStatus: [String: Bool] = [:]
        
        for route in allRouteInfos {
            var routeBusList: [CityBusLocation] = []
            
            for routeId in route.vehicleRouteIds {
                do {
                    let buses = try await CityBusService.getBusLocationData(routeId: routeId)
                    routeBusList.append(contentsOf: buses)
                } catch {
                    DebugLogger.log("[fecthAllBusLocations] routeName: \(route.routeName) routeId: \(routeId) fetch failed: \(error)")
                }
            }
            
            inactiveStatus[route.routeName] = routeBusList.isEmpty
            totalBusList.append(contentsOf: routeBusList)
        }
        
        self.allBusList = totalBusList
        self.isInactiveMap = inactiveStatus
        
        DebugLogger.log("[allBusList] count: \(allBusList.count)")
    }
    
    func startPolling() {
        pollingTask = Task {
            while !Task.isCancelled {
                await fetchAllBusLocations()
                try? await Task
                    .sleep(nanoseconds: Config.realtimeDataRefreshInterval)
            }
        }
    }
    
    func buses(for routeName: String) -> [CityBusLocation] {
        allBusList.filter { $0.routenm == routeName }
    }
    
    // MARK: - 방향 추론
    
    func getDirection(for bus: CityBusLocation, stops: [CityBusStopLocation]) -> Int? {
        let matchingStops = stops.filter { $0.nodeid == bus.nodeid }
        
        guard !matchingStops.isEmpty else {
            DebugLogger.log("[getDirection] nodeid \(bus.nodeid) matching failed")
            return nil
        }
        
        if matchingStops.count == 1 {
            return matchingStops[0].updowncd
        }
        
        let closestStop = matchingStops.min {
            abs($0.nodeord - bus.nodeord) < abs($1.nodeord - bus.nodeord)
        }
        
        return closestStop?.updowncd
    }
    
    // MARK: - 종료 로직
    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }
}
