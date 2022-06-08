//
//  Restaurant.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

struct Restaurant {
    var title : String
    var address : String
    var description : String
    var galery : [UIImage] = []
    
    var reviews : [(user : String, review : String)] = []
    var rating : Int?
    var id : Int?
    var location : (lat : Double, lon : Double)?
}

class RestaurantContainer {
    var container : Array<Restaurant> = []
    
    func addRestaurant(title : String, address : String, description : String) {
        var restaurant = Restaurant(title: title, address: address, description: description)
        container.append(restaurant)
    }
    
    
}
