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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is RestaurantAnnotation else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "RestaurantAnnotation")

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "RestaurantAnnotation")
            annotationView?.canShowCallout = true

            let annotationInRestaurantAnnotationFormat = annotation as! RestaurantAnnotation
            // add info button
            guard let restaurantId = annotationInRestaurantAnnotationFormat.id else {
                return nil
            }
            let restaurantInfoButton = UIButton(type: .detailDisclosure, primaryAction: UIAction() {_ in self.openRestaurantPage(restaurantId: restaurantId)})
            annotationView?.rightCalloutAccessoryView = restaurantInfoButton
            
            // add restaurant image
            let restaurantImage = annotationInRestaurantAnnotationFormat.image
            let newImageSize = CGSize(width: 60, height: 60)
            let render = UIGraphicsImageRenderer(size: newImageSize) // resize image
            let scaledRestaurantImage = render.image() { _ in restaurantImage?.draw(in: CGRect( origin: .zero, size: newImageSize))}
            annotationView?.leftCalloutAccessoryView = UIImageView(image: scaledRestaurantImage)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func openRestaurantPage(restaurantId : Int) {
        viewModel?.showRestaurantPage(id: restaurantId)
    }
}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
