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
        mapBox?.delegate = self
        
        // init location for the map
        let initialLocation = CLLocation(latitude: 54.868705, longitude: 83.122559)
        mapBox?.centerToLocation(initialLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add annotations
        guard let restaurantAnnotations = viewModel?.restaurantAnnotations() else {
            return
        }
        mapBox?.addAnnotations(restaurantAnnotations)
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let restaurant = view.annotation else {
            return
        }
        let annotation = restaurant as! RestaurantAnnotation
        viewModel?.showRestaurantPage(id: annotation.id)
    }
}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
