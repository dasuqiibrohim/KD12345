//
//  EndpointType.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation

protocol EndpointType {
    var baseUrl: String { get }
    var path: String { get }
    var parameter: [String: Any] { get }
    var header: String { get }
    var method: enMethod { get }
    var body: [String: Any] { get }
}

enum enMethod: String {
    case post  = "POST"
    case get   = "GET"
    case del   = "DELETE"
    case put   = "PUT"
}
