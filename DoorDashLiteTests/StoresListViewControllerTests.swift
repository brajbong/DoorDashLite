//
//  StoresListViewControllerTests.swift
//  DoorDashLiteTests
//
//  Created by Rajbongshi, Bhaskar on 6/17/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import XCTest
import MapKit
@testable import DoorDashLite

class StoresListViewControllerTests: XCTestCase {
    var sut: StoresListViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "StoresListViewController") as! StoresListViewController)
        sut.loadView()
        //sut.viewDidLoad()
    }
    
    func testStoresListViewControllerHasATableView() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testStoresListViewControllerConformsToDatasourceProtocol1() {
        XCTAssertTrue(sut.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:cellForRowAt:))))
    }
    
    func testStoresListViewControllerConformsToDatasourceProtocol2() {
        XCTAssertTrue(sut.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(sut.responds(to: #selector(sut.tableView(_:numberOfRowsInSection:))))
    }
    
    func testStoresListViewControllerTVHasDataSource() {
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func testStoresListViewControllerTableViewCellHasReuseIdentifier() {
        let viewModel = StoresListViewModel(storeService: StoreService(networking: NetworkService()), imageService: ImageService())
        sut.viewModel = viewModel
        sut.viewModel.stores = [Store()]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! StoresListCell
        let actualReuseIdentifer = cell.reuseIdentifier
        let expectedReuseIdentifier = "storesListCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testStoresListViewControllerNumberOfStoresInTableViewIsCorrect() {
        let viewModel = StoresListViewModel(storeService: StoreService(networking: NetworkService()), imageService: ImageService())
        sut.viewModel = viewModel
        sut.viewModel.stores = [Store(), Store()]
        let expectedNumOfStores = 2
        let actualNumOfStores = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(actualNumOfStores, expectedNumOfStores)
    }
    
    //the following also tests that the viewModel and the StoresListCell methods
    //that massages data for representation are working properly
    func testStoresListViewControllerStoreDetailDisplaysCorrectly() {
        let expectedName = "Mendocino Farms"
        let expectedDescription = "Sandwiches, Salads"
        let expectedDeliveryFee = 1025
        let coverImageUrl = "https://cdn.doordash.com/media/restaurant/cover/asian_box.png"
        let expectedAsapTime = 25
        let store = Store(id: 0, name: expectedName, description: expectedDescription, delivery_fee: expectedDeliveryFee, cover_image_url: coverImageUrl, asap_time: expectedAsapTime)
        let viewModel = StoresListViewModel(storeService: StoreService(networking: NetworkService()), imageService: ImageService())
        sut.viewModel = viewModel
        sut.viewModel.stores = [store]
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! StoresListCell
        XCTAssertEqual(cell.storeTitle.text, expectedName)
        XCTAssertEqual(cell.storeDescription.text, expectedDescription)
        XCTAssertEqual(cell.storeDelivery.text, "$\(10.25) delivery")
        XCTAssertEqual(cell.storeDeliveryTime.text, "25 min")
        XCTAssertNotNil(cell.storeImage, "Store image set it the cell is not nil.")
    }
    

    override func tearDown() {
        super.tearDown()
    }
}
