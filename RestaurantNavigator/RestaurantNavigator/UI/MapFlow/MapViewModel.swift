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
    var subtitle: String?
    var image : UIImage?

    var id : Int?
}

class MapViewModel {
    var dataContainer : DataContainerToRead?
    var actionDelegate : MapViewModelActionDelegate?
    
    func restaurantAnnotations() -> [RestaurantAnnotation] {
        guard let restaurantsInfo = dataContainer?.restaurantsInfo() else {
            return []
        }
        
        var annotaions : [RestaurantAnnotation] = []
        for restaurant in restaurantsInfo {
            let annotaion = RestaurantAnnotation()
            annotaion.title = restaurant.title
            annotaion.subtitle = restaurant.description
            annotaion.coordinate = CLLocationCoordinate2D(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
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

protocol MapViewModelActionDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
