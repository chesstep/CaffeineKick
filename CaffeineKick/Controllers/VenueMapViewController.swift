//
//  MapViewController.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let networkManager = NetworkManager()
    let locationManager = CLLocationManager()
    
    var venueService: VenueService!
    
    var currentLocation: CLLocationCoordinate2D?
    var selectedVenue: Venue?
    var venues: [Venue]!
    
    var isRetrievingVenues = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Venue Map", comment: "")
        
        venueService = VenueService(networkManager: networkManager)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 500
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    @IBAction func listViewAction(_ sender: UIBarButtonItem) {
        if venues.count > 0 {
            performSegue(withIdentifier: String(describing: VenueListViewController.self), sender: self)
        } else {
            let alertController = UIAlertController(title: NSLocalizedString("No Venues Loaded", comment: ""), message: NSLocalizedString("There aren't any venues loaded to list yet.", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let venueDetailViewController = segue.destination as? VenueDetailViewController, segue.identifier == String(describing: VenueDetailViewController.self) {
            venueDetailViewController.venue = selectedVenue
            venueDetailViewController.venueService = venueService
        } else if let venueListViewController = segue.destination as? VenueListViewController, segue.identifier == String(describing: VenueListViewController.self) {
            venueListViewController.venues = venues
            venueListViewController.venueService = venueService
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMap(position: CLLocationCoordinate2D?) {
        guard let position = position else {
            return
        }
        
        mapView.setCenter(position, animated: true)
        
        let zoomRegion = MKCoordinateRegionMakeWithDistance(position, 10000, 10000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func updateMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        for venue in venues {
            let annotation = VenueAnnotation(venue: venue)
            mapView.addAnnotation(annotation)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? VenueAnnotation else {
            return nil
        }
        
        let identifier = "VenueAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true

            let detailButton = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = detailButton
        }
        annotationView!.annotation = annotation
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? VenueAnnotation else {
            return
        }
        
        selectedVenue = annotation.venue
        performSegue(withIdentifier: String(describing: VenueDetailViewController.self), sender: self)
    }
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !isRetrievingVenues {
            isRetrievingVenues = true
            
            currentLocation = locations.first?.coordinate
            centerMap(position: currentLocation)
            
            if let currentLocation = currentLocation {
                venueService.retrieveVenues(latitude: currentLocation.latitude, longitude: currentLocation.longitude) { [weak self] venues in
                    if let venues = venues {
                        let sortedVenues = venues.sorted {
                            $0.location.distance < $1.location.distance
                        }
                        self?.venues = sortedVenues
                        DispatchQueue.main.async {
                            self?.updateMapAnnotations()
                        }
                    }
                    self?.isRetrievingVenues = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }    
}

