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
    var dataContainer : DataContainerToRead?
    var actionDelegate : ActionMapViewModelDelegate?
    
    func restaurantAnnotations() -> [RestaurantAnnotation] {
        guard let restaurantsInfo = dataContainer?.restaurantsInfo() else {
            return []
        }
        
        var annotaions : [RestaurantAnnotation] = []
        for restaurant in restaurantsInfo {
            let annotaion = RestaurantAnnotation()
            annotaion.title = restaurant.title
            annotaion.subtitle = restaurant.description
            annotaion.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitudinal, longitude: restaurant.longitudinal)
            annotaion.id = restaurant.id
            annotaion.image = restaurant.image
            
            annotaions.append(annotaion)
        }
        return annotaions
    }
    
    func showRestaurantPage(id : Int) {
        guard let restaurant = dataContainer?.element(id: id) else {
            return
        }
        actionDelegate?.willShow(restaurant: restaurant)
    }
}

protocol ActionMapViewModelDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
