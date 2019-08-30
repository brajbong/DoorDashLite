//
//  LocationMapSelectViewController.swift
//  DoorDashLite
//
//  Created by Rajbongshi, Bhaskar on 6/15/19.
//  Copyright © 2019 Rajbongshi, Bhaskar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationMapSelectViewController: UIViewController {
    typealias LocCoordinate = CLLocationCoordinate2D
    final let segIdentifer: String = "showStoresList"
    final let annotationIdentifier: String = "dd_annotation"
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var selectedAddress: UILabel!
    @IBOutlet weak var confirmAddress: UIButton!
    
    let locationManager =  CLLocationManager()
    var lastLocation: CLLocation?
    private let mapRegionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        map.delegate = self
        map.showsUserLocation = true
        map.setUserTrackingMode(.follow, animated: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        confirmAddress.isEnabled = false
    }

    private func setSelectedLocation(coordinate: LocCoordinate) {
        let curLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(curLocation) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemarks = placemarks, placemarks.count > 0 else { return }
            DispatchQueue.main.async {
                self.selectedAddress.text = placemarks[0].name ?? ""
                if !self.selectedAddress.text!.isEmpty {
                    self.confirmAddress.isEnabled = true
                }
            }
        }
    }
    
    private func updateAnnotation(coordinate: LocCoordinate) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: mapRegionRadius, longitudinalMeters: mapRegionRadius)
        map.setRegion(region, animated: true)
        //add a new annotation
        let curPlace = MKPointAnnotation()
        curPlace.coordinate = coordinate
        map.addAnnotation(curPlace)
        //reverse geocode and set location in the label
        setSelectedLocation(coordinate: coordinate)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ddTabController = segue.destination as? DDTabBarController {
            ddTabController.viewModel.mapCoordinates.latitude = map.centerCoordinate.latitude
            ddTabController.viewModel.mapCoordinates.longitude = map.centerCoordinate.longitude
        }
    }
    
    @IBAction private func confirmAddressTapped(_ sender: UIButton) {
        performSegue(withIdentifier: segIdentifer, sender: nil)
    }
}

extension LocationMapSelectViewController {
    private func checkLocAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationMapSelectViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        locationManager.stopUpdatingLocation()
        updateAnnotation(coordinate: userLocation.coordinate)
    }
    
    @objc func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = annotationIdentifier
        var annotationView = map.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isDraggable = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        map.removeAnnotations(mapView.annotations)
        updateAnnotation(coordinate: mapView.region.center)
    }
}
