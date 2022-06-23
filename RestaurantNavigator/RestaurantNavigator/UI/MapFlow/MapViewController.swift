//
//  MapViewController.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MapViewModelDisplayDelegate {
    
    @IBOutlet var mapView : MKMapView?
    
    var viewModel : MapViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
        
        // init location for the map
        let initLocation = CLLocation(latitude: 54.868705, longitude: 83.122559) // maybe set user location???
        mapView?.centerToLocation(initLocation)
        
        guard let restaurantAnnotations = viewModel?.restaurantAnnotations() else {
            return
        }
        mapView?.addAnnotations(restaurantAnnotations)
    }
    
    // protocol function
    func dataDidLoad(annotations: [Restaurant]) {
        if let oldAnnotations = mapView?.annotations {
            mapView?.removeAnnotations(oldAnnotations)
        }
        mapView?.addAnnotations(annotations)
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Restaurant else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "RestaurantAnnotation")

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "RestaurantAnnotation")
            annotationView?.canShowCallout = true
        }
        
        configureAnnotationView(&annotationView, annotation: annotation)
        return annotationView
    }
    
    func openRestaurantPage(restaurantId : Int) {
        viewModel?.showRestaurantPage(id: restaurantId)
    }
    
    func configureAnnotationView(_ view : inout MKAnnotationView?, annotation : MKAnnotation) {
        view?.annotation = annotation
        
        let annotationInRestaurantAnnotationFormat = annotation as! Restaurant
        // add info button
        view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure, primaryAction: UIAction() {_ in self.openRestaurantPage(restaurantId: annotationInRestaurantAnnotationFormat.id)})
        
        // add restaurant image
        let restaurantImage = annotationInRestaurantAnnotationFormat.image
        let scaledRestaurantImage = resizeImage(restaurantImage, newSize : CGSize(width: 60, height: 60))
        view?.leftCalloutAccessoryView = UIImageView(image: scaledRestaurantImage)
    }
}

func resizeImage(_ image : UIImage, newSize : CGSize) -> UIImage {
    let render = UIGraphicsImageRenderer(size: newSize) // resize image
    let scaledRestaurantImage = render.image() { _ in image.draw(in: CGRect( origin: .zero, size: newSize))}
    return scaledRestaurantImage
}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
