//
// LosslessValueDecodable.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

@propertyWrapper
struct LosslessValueDecodable<T: LosslessStringConvertible>: Codable {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intVal = try? container.decode(Int.self),
           let converted = T(String(intVal)) {
            self.wrappedValue = converted
        } else if let doubleVal = try? container.decode(Double.self),
                  let converted = T(String(doubleVal)) {
            self.wrappedValue = converted
        } else if let stringVal = try? container.decode(String.self),
                  let converted = T(stringVal) {
            self.wrappedValue = converted
        } else {
            throw DecodingError.typeMismatch(
                T.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Expected \(T.self) as Int, Double or String")
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(wrappedValue))
    }
}
