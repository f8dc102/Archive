//
// APIClient.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}
    
    func request<T: Decodable>(
        _ path: String,
        retries: Int = Config.apiRetries,
        retryDelay: UInt64 = Config.retryDelay,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: Config.apiBaseURL + path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Config.contentType, forHTTPHeaderField: "Content-Type")
        request.setValue(Config.clientHeader, forHTTPHeaderField: "Client")
        
        var lastError: Error?
        
        for attempt in 0..<retries {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                DebugLogger.log(
                    "📦 Raw 응답: \(String(data: data, encoding: .utf8) ?? "N/A")"
                )
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode) else {
                    throw APIError.requestFailed((response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                
                return try JSONDecoder().decode(T.self, from: data)
                
            } catch {
                DebugLogger.log("❌ API 호출 에러: \(error)")
                
                lastError = error
                if attempt < retries - 1 {
                    try? await Task.sleep(nanoseconds: retryDelay)
                }
            }
        }
        
        throw lastError ?? APIError.unknown(NSError(domain: "", code: -1))
    }
}
