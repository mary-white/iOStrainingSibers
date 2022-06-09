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
    
    var count : Int {
        get {
            return container.count
        }
    }
    
    func addRestaurant(title : String, address : String, description : String, id : Int) {
        let restaurant = Restaurant(title: title, address: address, description: description, id: id)
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
        for i in 0..<container.count {
            if container[i].id != id {
                continue
            }
            
            container[i].galery.append(newImage)
            break
        }
    }
}
