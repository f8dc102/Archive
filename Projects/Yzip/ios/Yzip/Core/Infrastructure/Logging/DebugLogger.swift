//
// DebugLogger.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

enum DebugLogger {
    static let enabled = Config.debug
    
    static func log(_ message: @autoclosure () -> String) {
        if enabled {
            print("DEBUG / \(message())")
        }
    }
}
