//
//  MapViewController.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapBox : MKMapView?
    
    var viewModel : MapViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add annotations
        guard let restaurantAnnotations = viewModel?.restaurantAnnotations() else {
            return
        }
        mapBox?.addAnnotations(restaurantAnnotations)
        
        // init location for the map
        let firstLocation = restaurantAnnotations[0].coordinate
        let initialLocation = CLLocation(latitude: firstLocation.latitude, longitude: firstLocation.longitude)
        mapBox?.centerToLocation(initialLocation)
    }
}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
