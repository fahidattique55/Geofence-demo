//
//  ViewController.swift
//  TestGeofence
//
//  Created by Fahad Attique on 01/08/2019.
//  Copyright © 2019 UMAI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deviceLatitude: UILabel!
    @IBOutlet weak var deviceLongitude: UILabel!
    @IBOutlet weak var wifiName: UILabel!
    @IBOutlet weak var isInsideGeofence: UILabel!
    
    // MARK: - Class Properties

    let locationManager = CLLocationManager()
    var deviceAnnotation = MKPointAnnotation()
    var mapSelectorManager: DBMapSelectorManager!
    var deviceCurrentLocation: CLLocationCoordinate2D!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViews()
    }

    // MARK: - Functions

    private func configureViews() {
        
        configureLocationServices()
        configureMapSelectorManager()
    }
    
    private func configureLocationServices() {
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    private func configureMapSelectorManager() {
        
        mapSelectorManager = DBMapSelectorManager(mapView: mapView)
        mapSelectorManager.delegate = self
        mapSelectorManager.circleCoordinate = CLLocationCoordinate2DMake(3.1579, 101.7120)
        mapSelectorManager.circleRadius = 3000
        mapSelectorManager.circleRadiusMax = 100000
        mapSelectorManager.fillColor = UIColor.red
        mapSelectorManager.strokeColor = UIColor.darkGray
        mapSelectorManager.isFillInside = true
        mapSelectorManager.editingType = .full
        mapSelectorManager.isHidden = false
        mapSelectorManager.applySelectorSettings()
    }
    
    private func checkIfDeviceIsUnderGeofence() {
        
        guard let location = deviceCurrentLocation else { return }

        let region = CLCircularRegion(center: mapSelectorManager.circleCoordinate, radius: mapSelectorManager.circleRadius, identifier: "geofencing")
        if region.contains(location) {
            mapSelectorManager.fillColor = UIColor.orange
            isInsideGeofence.text = "Yes"
        }
        else {
            mapSelectorManager.fillColor = UIColor.red
            isInsideGeofence.text = "No"
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func changeLocation(_ sender: Any) {
        
        deviceCurrentLocation = appUtility.randomCoordinates[Int.random(in: 0 ..< appUtility.randomCoordinates.count)]
        updateUIStatesForCurrentLocation()
    }

    private func updateUIStatesForCurrentLocation() {
        guard let location = deviceCurrentLocation else { return }
        deviceLatitude.text = "\(location.latitude)"
        deviceLongitude.text = "\(location.longitude)"
        checkIfDeviceIsUnderGeofence()
        
        mapView.removeAnnotation(deviceAnnotation)
        deviceAnnotation.coordinate = deviceCurrentLocation
        deviceAnnotation.title = "Device Location"
        mapView.addAnnotation(deviceAnnotation)
    }
}


extension ViewController: DBMapSelectorManagerDelegate, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return mapSelectorManager.mapView(mapView, viewFor: annotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        mapSelectorManager.mapView(mapView, annotationView: view, didChange: newState, fromOldState: oldState)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return mapSelectorManager.mapView(mapView, rendererFor: overlay)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapSelectorManager.mapView(mapView, regionDidChangeAnimated: animated)
    }
    
    func mapSelectorManager(_ mapSelectorManager: DBMapSelectorManager!, didChange coordinate: CLLocationCoordinate2D) {
        updateUIStatesForCurrentLocation()
    }
    
    func mapSelectorManager(_ mapSelectorManager: DBMapSelectorManager!, didChangeRadius radius: CLLocationDistance) {
        updateUIStatesForCurrentLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        deviceCurrentLocation = manager.location?.coordinate
        print("location = \(deviceCurrentLocation.latitude) \(deviceCurrentLocation.longitude)")
        updateUIStatesForCurrentLocation()
    }
}
