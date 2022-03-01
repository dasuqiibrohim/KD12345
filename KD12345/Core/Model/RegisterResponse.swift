//
//  RegisterResponse.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let success: Bool
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let email, updatedAt, createdAt: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case email
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
