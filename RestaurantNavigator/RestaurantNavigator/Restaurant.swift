//
//  Restaurant.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class Restaurant {
    var title : String
    var address : String
    var description : String
    var galery : [UIImage] = []
    
    var reviews : [(user : String, review : String)] = []
    var rating : Int?
    var id : Int?
    var location : (lat : Double, lon : Double)?
    
    init(title : String, address : String, description : String) {
        self.title = title
        self.address = address
        self.description = description
    }
}
