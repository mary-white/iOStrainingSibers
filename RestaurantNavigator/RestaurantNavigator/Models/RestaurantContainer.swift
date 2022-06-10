//
//  Restaurant.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

struct Restaurant {
    var id : Int
    var title : String
    var address : String
    var description : String
    var galery : [UIImage] = []
    
    var reviews : [(user : String, review : String)] = []
    var rating : Int?
    var location : (lat : Double, lon : Double)?
}

class RestaurantContainer : DataContainerToRead {
    var container : Array<Restaurant> = []
    
    var count : Int {
        get {
            return container.count
        }
    }
    
    func addRestaurant(title : String, address : String, description : String, id : Int) {
        let restaurant = Restaurant(id: id, title: title, address: address, description: description)
        container.append(restaurant)
    }
    
    func element(at index : Int) -> Restaurant? {
        if index >= container.count || index < 0 {
            return nil
        }
        return container[index]
    }
    
    func removeAll() {
        container.removeAll()
    }
    
    func addImageToGalery(at_id id : Int, newImage : UIImage) {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].galery.append(newImage)
    }
    
    func setRestaurantCoordinats(_ coordinats : (lat : Double, lon : Double), at_id id : Int) {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].location = coordinats
    }
    
    // protocol functions
    func restaurantListCoordinats() -> [(title: String, latitudinal: Double, longitudinal: Double)] {
        var result : [(title: String, latitudinal: Double, longitudinal: Double)] = []
        for restaurant in container {
            if let location = restaurant.location {
                result.append((title: restaurant.title, latitudinal: location.lat, longitudinal: location.lon))
            }
        }
        return result
    }
}