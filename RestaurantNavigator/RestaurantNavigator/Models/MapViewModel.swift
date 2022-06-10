//
//  MapViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import MapKit

class MapViewModel {
    var dataContainer : DataContainerToRead?
    
    func restaurantAnnotations() -> [MKAnnotation] {
        guard let restaurantLocations = dataContainer?.restaurantListCoordinats() else {
            return []
        }
        
        var annotaions : [MKAnnotation] = []
        for restaurant in restaurantLocations {
            let annotaion = MKPointAnnotation()
            annotaion.title = restaurant.title
            annotaion.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitudinal, longitude: restaurant.longitudinal)
            annotaions.append(annotaion)
        }
        return annotaions
    }
}

protocol DataContainerToRead {
    func restaurantListCoordinats() -> [(title : String, latitudinal : Double, longitudinal : Double)]
}
