//
// APIError.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//
        
enum APIError: Error {
    case invalidURL
    case requestFailed(Int)
    case decodingFailed
    case unknown(Error)
}

extension APIError {
    static func map(error: Error) -> Self {
        switch error {
            // Add mapping logic here if needed
        default:
            return .unknown(error)
        }
    }
}
