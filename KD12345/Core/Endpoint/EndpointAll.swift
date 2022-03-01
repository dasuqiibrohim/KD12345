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
    case AddProducts(prod: ItemProductResponse)
    case UpdateProducts(prod: ItemProductResponse)
    case DeleteProducts(sku: String)
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
    var header: [String : String] {
        switch self {
        case .Register, .Login, .ListProducts:
            return [
                "Accept": "application/json",
                "Content-Type": "application/from-data"
            ]
        default:
            return [
                "Accept": "application/json",
                "Content-Type": "application/from-data",
                "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiZWFyZXIiLCJzdWIiOjEyOSwiaWF0IjoxNjQ2MTcyMDQ3LCJleHAiOjE2NDYxNzU2NDd9.iW8Dey59l0JhR6TOqNLOyT1of0MeYHdhKPHl969MXDQ"
            ]
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
        case .AddProducts(let prod), .UpdateProducts(let prod):
            return [
                "sku": prod.sku,
                "product_name": prod.productName,
                "qty": prod.qty.endcodeStr(),
                "price": prod.price.endcodeStr(),
                "unit": prod.unit,
                "status": prod.status.endcodeStr()
            ]
        case .DeleteProducts(let sku):
            return [
                "sku": sku
            ]
        default:
            return [:]
        }
    }
}
