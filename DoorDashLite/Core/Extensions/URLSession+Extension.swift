//
//  URLSession+Extension.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badConnection
    case badData
    case badURL
    case badResponse
}
typealias Handler<T> = (Result<T, NetworkError>) -> Void

extension URLSession: NetworkSession {
    @discardableResult
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask {
        let dt: URLSessionDataTask = dataTask(with: urlRequest) { (data, response, error) in
            guard  error == nil else {
                completionHandler(.failure(NetworkError.badConnection))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(NetworkError.badResponse))
                return
            }
            
            if self.isResponseOK(response) {
                guard let data = data else {
                    completionHandler(.failure(NetworkError.badData))
                    return
                }
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(NetworkError.badResponse))
            }
        }
        dt.resume()
        return dt
    }
    
    fileprivate func isResponseOK(_ response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200...299:
            return true
        default:
            return false
        }
    }
}
