//
//  MapViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import MapKit

extension Restaurant : MKAnnotation {
    var coordinate : CLLocationCoordinate2D {
        get {
            return location
        }
        set {
            location = newValue
        }
    }
    var subtitle: String? {
        get {
            return restaurantDescription
        }
        set {
            restaurantDescription = newValue ?? ""
        }
    }
}

class MapViewModel : RemoteDataServiceDelegate {
    var dataContainer : DataContainerToRead?
    var actionDelegate : MapViewModelActionDelegate?
    var displayDelegate : MapViewModelDisplayDelegate?
    
    func restaurantAnnotations() -> [Restaurant] {
        guard let restaurantsInfo = dataContainer?.restaurantsInfo() else {
            return []
        }
        
        var annotaions : [Restaurant] = []
        for restaurant in restaurantsInfo {
            let annotaion = Restaurant()
            annotaion.title = restaurant.title
            annotaion.subtitle = restaurant.restaurantDescription
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
    
    // protocol function
    func dataDidLoad() {
        displayDelegate?.dataDidLoad(annotations: restaurantAnnotations())
    }
}

protocol MapViewModelActionDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}

protocol MapViewModelDisplayDelegate {
    func dataDidLoad(annotations: [Restaurant])
}
