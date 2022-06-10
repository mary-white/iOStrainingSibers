//
//  File.swift
//  RestaurantNavigator
//
//  Created by student on 09.06.2022.
//

import Foundation
import UIKit

class RestaurantPageViewModel {
    var currentRestaurant : Restaurant?
    var restaurantReviews : [Review]
    
    init(restaurant : Restaurant) {
        currentRestaurant = restaurant
        restaurantReviews = currentRestaurant?.reviews ?? []
    }
    
    func restaurantInfo() -> (title : String, description : String, gallery : [UIImage]) {
        return (title: currentRestaurant?.title ?? "", description: currentRestaurant?.description ?? "", gallery: currentRestaurant?.galery ?? [])
    }
    
    var reviewsCount: Int {
        get {
            return restaurantReviews.count
        }
    }
    
    func review(at index : Int) -> (author : String,  date : String, text : String) {
        let review = restaurantReviews[index]
        return (author : review.author, date : review.date, text : review.reviewText)
    }
}
