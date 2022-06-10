//
//  MapViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title : String?

    var id : Int = -1
}

class MapViewModel {
    var dataContainer : DataContainerToRead?
    var actionDelegate : ActionMapViewModelDelegate?
    
    func restaurantAnnotations() -> [RestaurantAnnotation] {
        guard let restaurantLocations = dataContainer?.restaurantCoordinatsList() else {
            return []
        }
        
        var annotaions : [RestaurantAnnotation] = []
        for restaurant in restaurantLocations {
            let annotaion = RestaurantAnnotation()
            annotaion.title = restaurant.title
            annotaion.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitudinal, longitude: restaurant.longitudinal)
            annotaion.id = restaurant.id
            
            annotaions.append(annotaion)
        }
        return annotaions
    }
    
    func showRestaurantPage(id : Int) {
        guard let restaurant = dataContainer?.element(at_id: id) else {
            return
        }
        actionDelegate?.willShow(restaurant: restaurant)
    }
}

protocol DataContainerToRead {
    func restaurantCoordinatsList() -> [(title : String, id : Int, latitudinal : Double, longitudinal : Double)]
    func element(at_id id : Int) -> Restaurant?
}

protocol ActionMapViewModelDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
