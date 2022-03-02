//
//  ListProductsResponse.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation

// MARK: - WelcomeElement
struct ItemProductResponse: Codable, Identifiable {
    let id: Int
    let sku, productName: String
    let qty, price: StrInt
    let unit: String
    let image: String?
    let status: StrInt
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, sku
        case productName = "product_name"
        case qty, price, unit, image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias ListProductsResponse = [ItemProductResponse]

enum StrInt: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(StrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Qty"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    func endcodeStr() -> String {
        switch self {
        case .string(let d):
            return d
        case .integer(let d):
            return String(d)
        }
    }
    
    func endcodeInt() -> Int {
        switch self {
        case .string(let d):
            return Int(d) ?? 0
        case .integer(let d):
            return d
        }
    }
}
