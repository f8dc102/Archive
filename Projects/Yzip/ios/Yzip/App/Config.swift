//
// Config.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

enum Config {
    /// Genera
    // App Info
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let appBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    // Debug
    static let debug: Bool = true
    
    // API Settings
    static let apiBaseURL = "https://gl87xfcx95.execute-api.ap-northeast-2.amazonaws.com"
    static let contentType: String = "application/json"
    static let clientHeader: String = "Yzip"
    static let apiRetries: Int = 3
    static let retryDelay: UInt64 = 1_000_000_000
    
    // Realtime Data Refresh Interval
    static let realtimeDataRefreshInterval: UInt64 = 3_000_000_000
    
    /// Transit Bus Map
    // Default Map Location
    static let defaultMapLocation = miraeCampusLocation
    static let defaultMapZoomLevel: Float = 15.0
    
    // Campus Location
    static let sinchonCampusLocation: (latitude: Double, longitude: Double) = (37.56448575926606, 126.93891296250558)
    static let internationalCampusLocation: (latitude: Double, longitude: Double) = (37.38171428416945, 126.67056068642053)
    static let miraeCampusLocation: (latitude: Double, longitude: Double) = (37.28105231250697, 127.90124519732706)
    
    // Icon Size
    static let busStopIconSize: CGSize = CGSize(width: 12, height: 12)
    
    // Card Components
    static let busCardProgressThresholdMinutes: Double = 7
}
