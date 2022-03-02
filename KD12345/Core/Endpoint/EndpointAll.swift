//
//  EndpointAll.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation

enum EndpointAll: EndpointType {
    case Register(email: String, password: String)
    case Login(email: String, password: String)
    case AddProducts(token: String, prod: ItemProductResponse)
    case UpdateProducts(token: String, prod: ItemProductResponse)
    case DeleteProducts(token: String, sku: String)
    case ListProducts
}

extension EndpointAll {
    var baseUrl: String {
        return "https://hoodwink.medkomtek.net/api/"
    }
    var path: String {
        switch self {
        case .Register:
            return "register"
        case .Login:
            return "auth/login"
        case .AddProducts:
            return "item/add"
        case .UpdateProducts:
            return "item/update"
        case .DeleteProducts:
            return "item/delete"
        case .ListProducts:
            return "items"
        }
    }
    var parameter: [String : Any] {
        return [:]
    }
    var header: String {
        switch self {
        case .AddProducts(let token, _), .UpdateProducts(let token, _), .DeleteProducts(let token, _):
            return "Bearer \(token)"
        default:
            return ""
        }
    }
    var method: enMethod {
        switch self {
        case .ListProducts:
            return .get
        default:
            return .post
        }
    }
    var body: [String: Any] {
        switch self {
        case .Register(let email, let password), .Login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .AddProducts(_, let prod), .UpdateProducts(_, let prod):
            return [
                "sku": prod.sku,
                "product_name": prod.productName,
                "qty": prod.qty.endcodeStr(),
                "price": prod.price.endcodeStr(),
                "unit": prod.unit,
                "status": prod.status.endcodeStr()
            ]
        case .DeleteProducts(_, let sku):
            return [
                "sku": sku
            ]
        default:
            return [:]
        }
    }
}
