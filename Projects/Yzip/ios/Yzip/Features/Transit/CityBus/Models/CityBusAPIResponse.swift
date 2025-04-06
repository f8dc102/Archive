//
// CityBusAPIResponse.swift
// Yzip
//
// Created 4/4/25
// Copyright © 2025 Yzip. All rights reserved.
//

struct CityBusAPIResponse<T: Decodable>: Decodable {
    let response: CityBusResponseBody<T>
    
    var items: [T] {
        response.body.items.item
    }
}

struct CityBusResponseBody<T: Decodable>: Decodable {
    let body: CityBusBody<T>
}

struct CityBusBody<T: Decodable>: Decodable {
    let items: CityBusItems<T>
    let numOfRows: Int?
    let pageNo: Int?
    let totalCount: Int?
}

struct CityBusItems<T: Decodable>: Decodable {
    let item: [T]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let dict = try? container.decode([String: [FailableDecodable<T>]].self) {
            self.item = dict["item"]?.compactMap { $0.value } ?? []
        }
        else if let string = try? container.decode(String.self), string.isEmpty {
            self.item = []
        }
        else {
            throw DecodingError.typeMismatch(
                [T].self,
                .init(codingPath: decoder.codingPath, debugDescription: "items decoding failed")
            )
        }
    }
}
