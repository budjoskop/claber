//
//  Contact.swift
//  claber
//
//  Created by ognjen on 1/21/18.
//  Copyright © 2018 Ognjen Tomić. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapController: UIViewController {
    
    var clubName:String?
    var clubAdress:String?
    var latitude: Double?
    var longitude: Double?
    
    
    @IBOutlet weak var mapOutlet: MKMapView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print (latitude!)
        mapOutlet.delegate = self
        let initialLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        centerMapOnLocation(location: initialLocation)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let artwork = ClubLocation(title: "\(clubName!)",
            locationName: "\(clubAdress!)",
                              discipline: "Klub",
                              coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
        mapOutlet.addAnnotation(artwork)
       
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapOutlet.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
}

extension MapController: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? ClubLocation else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ClubLocation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
