//
// FailableDecodable.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

struct FailableDecodable<T: Decodable>: Decodable {
    let value: T?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try? container.decode(T.self)
    }
}
