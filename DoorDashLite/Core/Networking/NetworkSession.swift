//
//  NetworkSession.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/16/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation

protocol NetworkSession {
    @discardableResult
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask
}
