//
// RouteInfo.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

struct RouteInfo: Equatable, Hashable {
    let routeName: String // 사용자에게 보여주는 노선 이름
    let representativeRouteId: String // TAGO API 요청용
    let vehicleRouteIds: [String] // 실시간 위치 요청용
}
