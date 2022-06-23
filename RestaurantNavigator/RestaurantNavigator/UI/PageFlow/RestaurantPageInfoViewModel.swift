//
//  RestaurantPageInfoViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 23.06.2022.
//

import Foundation
import UIKit

struct RestaurantInfoViewModel : RestaurantPageInfoViewModelProtocol {
    var title : String
    var description : String
    var image : UIImage
    var address : String
    
    init(restaurant : Restaurant) {
        title = restaurant.title ?? ""
        description = restaurant.restaurantDescription
        image = restaurant.gallery.isEmpty ? UIImage() : restaurant.gallery[0]
        address = restaurant.address
    }
    
    init() {
        title = ""
        description = ""
        image = UIImage()
        address = ""
    }
}
