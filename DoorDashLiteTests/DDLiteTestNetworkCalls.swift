    //
    //  DDLiteTestNetworkCalls.swift
    //  DoorDashLiteTests
    //
    //  Created by Rajbongshi, Bhaskar on 6/16/19.
    //  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
    //

import XCTest
@testable import DoorDashLite

class DDLiteNetworkTest: XCTestCase {
    //To test that we actually request the URL we asked for.
    func testStoresFetchLoadsCorrectURL() {
        //given
        let url = URL(string: "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956")!
        let networkSessionMock = NetworkSessionMockCorrectURL()
        let expectation = XCTestExpectation(description: "Downloading stores.")
    
        //when
        networkSessionMock.dataTask(with: URLRequest(url: url)) { result in
            XCTAssertEqual(url, networkSessionMock.lastURL)
            expectation.fulfill()
        }
    
        //then
        wait(for: [expectation], timeout: 5.0)
    }
    
    //To test that a network request was actually started
    func testStoresFetchCallsResume() {
        //given
        let url = URL(string: "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956")!
        let networkSessionMock = NetworkSessionMockNetworkRequestMade()
        let expectation = XCTestExpectation(description: "Downloading stores triggers resume().")
        
        //when
        networkSessionMock.dataTask(with: URLRequest(url: url)) { result in
            XCTAssertFalse(networkSessionMock.dataTask?.resumeWasCalled ?? false)
            expectation.fulfill()
        }
        
        //then
        wait(for: [expectation], timeout: 5.0)
    }
    
    //To test that we get back proper data
    func testStoresFetchGetBackData() {
        //given
        let url = URL(string: "https://api.doordash.com/v1/store_search/?lat=37.42274&lng=-122.139956")!
        let networkSessionMock = NetworkSessionGetCorrectPresetData()
        networkSessionMock.testData = Data("Door Dash Network Data Test".utf8)
        let expectation = XCTestExpectation(description: "Downloading stores get back preset data.")
        
        //when
        networkSessionMock.dataTask(with: URLRequest(url: url)) { result in
            if case .success(let data) = result {
                XCTAssertEqual(String(decoding: data, as: UTF8.self), "Door Dash Network Data Test")
                expectation.fulfill()
            }
        }
        
        //then
        wait(for: [expectation], timeout: 5.0)
    }
    
    

}
