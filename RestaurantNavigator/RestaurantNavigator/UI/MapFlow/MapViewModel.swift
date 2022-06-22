//
//  MapViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import MapKit

class RestaurantAnnotation: MKPinAnnotationView, MKAnnotation {
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title : String?
    var subtitle: String?

    var id : Int?
}

class MapViewModel {
    var dataService : RemoteDataService? {
        didSet {
            dataService?.updateRestaurantData {
                guard let restaurantsInfo = self.dataContainer?.restaurantsInfo() else {
                    return
                }
                
                for restaurant in restaurantsInfo {
                    let annotation = RestaurantAnnotation()
                    annotation.title = restaurant.title
                    annotation.subtitle = restaurant.description
                    annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitudinal, longitude: restaurant.longitudinal)
                    annotation.id = restaurant.id
                    annotation.image = restaurant.image
                    
                    self.annotations.append(annotation)
                }
            }
        }
    }
    var dataContainer : DataContainerToRead?
    var actionDelegate : MapViewModelActionDelegate?
    
    var annotations : [RestaurantAnnotation] = []
    
    func restaurantAnnotations() -> [RestaurantAnnotation] {
        return annotations
    }
    
    func showRestaurantPage(id : Int) {
        guard let restaurant = dataContainer?.element(id: id) else {
            return
        }
        actionDelegate?.willShow(restaurant: restaurant)
    }
}

protocol MapViewModelActionDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
