//
//  Network.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation

final class Network<T: Decodable> {
    func fetch(_ endPoint: EndpointType, completionHandler: @escaping (Result<T, Error>) -> Void) {
        let completeUrl = endPoint.baseUrl + endPoint.path
        var urlRequest = URLRequest(url: URL(string: completeUrl)!, timeoutInterval: 15)
        //urlRequest.allHTTPHeaderFields = endPoint.header
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        urlRequest.addValue(endPoint.header, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = endPoint.method.rawValue
        if !endPoint.body.isEmpty {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: endPoint.body, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        dump(completeUrl)
        dump(endPoint.body)
        URLSession.shared.dataTask(with: urlRequest) {data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        completionHandler( Result{ try JSONDecoder().decode(T.self, from: data!)})
                    }
                }
            }
        }.resume()
    }
}
