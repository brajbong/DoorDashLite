//
//  NetworkSessionMock.swift
//  DoorDashLiteTests
//
//  Created by Rajbongshi, Bhaskar on 6/16/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import Foundation
@testable import DoorDashLite

class NetworkSessionMockCorrectURL: NetworkSession {
    var lastURL: URL?
    let success = true
    
    @discardableResult
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask {
        defer { completionHandler(.success(Data.init())) }
        lastURL = urlRequest.url
        return URLSessionDataTask()
    }
}

class DataTaskMock: URLSessionDataTask {
    var completionHandler: Handler<Data>
    var resumeWasCalled = false
    init(completionHandler: @escaping Handler<Data>) {
        self.completionHandler = completionHandler
    }
 
    override func resume() {
        resumeWasCalled = true
        completionHandler(.success(Data.init()))
    }
}
class NetworkSessionMockNetworkRequestMade: NetworkSession {
    var dataTask: DataTaskMock?

    @discardableResult
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask {
        let newDataTask = DataTaskMock(completionHandler: completionHandler)
        newDataTask.resume()
        dataTask = newDataTask
        return newDataTask
    }
}

class DataTaskMockGetData: URLSessionDataTask {
    override func resume() {
    }
}

class NetworkSessionGetCorrectPresetData: NetworkSession {
    var testData: Data?

    @discardableResult
    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping Handler<Data>) -> URLSessionDataTask {
        defer { completionHandler(.success(testData!)) }
        return DataTaskMockGetData()
    }
}
