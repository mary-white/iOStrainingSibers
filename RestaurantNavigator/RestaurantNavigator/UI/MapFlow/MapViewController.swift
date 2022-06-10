//
//  MapViewController.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView : MKMapView?
    
    var viewModel : MapViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
        
        // init location for the map
        let initLocation = CLLocation(latitude: 54.868705, longitude: 83.122559) // maybe set user location???
        mapView?.centerToLocation(initLocation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add annotations
        guard let restaurantAnnotations = viewModel?.restaurantAnnotations() else {
            return
        }
        mapView?.addAnnotations(restaurantAnnotations)
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
