//
//  LocationMapSelectViewControllerTests.swift
//  DoorDashLiteTests
//
//  Created by Rajbongshi, Bhaskar on 6/17/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import XCTest
import MapKit
@testable import DoorDashLite

class LocationMapSelectViewControllerTests: XCTestCase {
    var sut: LocationMapSelectViewController!

    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = (storyboard.instantiateViewController(withIdentifier: "LocationMapSelectViewController") as! LocationMapSelectViewController)
        sut.loadView()
        sut.viewDidLoad()
    }
    
    func testLocationMapSelectViewControllerIsComposedOfMapView() {
        XCTAssertNotNil(sut.map, "LocationMapSelectViewController is not composed of a MKMapView.")
    }
    
    func testLocationMapSelectViewControllerConformsToMKMapViewDelegate() {
        XCTAssert(sut.conforms(to: MKMapViewDelegate.self), "LocationMapSelectViewController does not conform to MKMapViewDelegate protocol.")
    }
    
    func testLocationMapSelectViewControllerMapViewDelegateIsSet() {
        XCTAssertNotNil(sut.map.delegate, "LocationMapSelectViewController MKMapViewDelegate is not set.")
    }

    func testLocationMapSelectViewControllerImplementsMKMapViewDelegateMethodDidUpdateLocation() {
        XCTAssert(sut.responds(to: #selector(MKMapViewDelegate.mapView(_:didUpdate:))), "ViewController under test does not implement mapView:DidUpdateUserLocation")
    }
    
    func testLocationMapSelectViewControllerImplementsMKMapViewDelegateMethodViewForAnnotation() {
        XCTAssert(sut.responds(to: #selector(MKMapViewDelegate.mapView(_:viewFor:))), "ViewController under test does not implement mapView:viewForAnnotation")
    }
    
    func testLocationMapSelectViewControllerShowsAddedLocationAnnotation() {
        let curPlace = MKPointAnnotation()
        curPlace.coordinate = CLLocationCoordinate2D(latitude: 37.42274, longitude: -122.139956)
        sut.map.addAnnotation(curPlace)
        let annotationsOnMap = sut.map.annotations
        XCTAssertGreaterThan(annotationsOnMap.count, 0)
    }
    
    func testLocationMapSelectViewControllerSetsSelectedLocationInSelectedAddressLabel() {
        let curPlace = MKPointAnnotation()
        curPlace.coordinate = CLLocationCoordinate2D(latitude: 37.42274, longitude: -122.139956)
        sut.map.centerCoordinate = curPlace.coordinate
        XCTAssertNotNil(sut.selectedAddress.text)
    }

    override func tearDown() {
        sut = nil
    }
}
