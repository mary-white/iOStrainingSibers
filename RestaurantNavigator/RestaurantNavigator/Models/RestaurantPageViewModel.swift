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
    
    var displayDelegate : DisplayRestaurantPageViewModelDelegate?
    var actionDelegate : ActionRestaurantPageViewModelDelegate?
    
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
    
    func addNewReview(author : String, text : String) {
        guard let id = currentRestaurant?.id else {
            return
        }
        
        actionDelegate?.addNewReview(author: author, text: text, restaurantId : id, date : String(describing: NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)))
        displayDelegate?.reviewDidLoad()
    }
}

protocol ActionRestaurantPageViewModelDelegate {
    func addNewReview(author : String, text : String, restaurantId : Int, date : String)
}

protocol DisplayRestaurantPageViewModelDelegate {
    func reviewDidLoad()
}
