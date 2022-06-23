//
//  RestaurantCellViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 23.06.2022.
//

import Foundation
import UIKit

struct RestaurantCellViewModel {
    var title : String
    var description : String
    var image : UIImage
    
    init(restaurant : Restaurant) {
        title = restaurant.title
        description = restaurant.description
        image = restaurant.gallery.isEmpty ? UIImage() : restaurant.gallery[0]
    }
}
