//
//  RatingView.swift
//  RestaurantNavigator
//
//  Created by student on 24.06.2022.
//

import Foundation

let ratingStarCount = 5
let maxRatingValue = 5.0

class RatingView {
    var maxValue : Double
    var starCount : Int
    var rating : Double
    
    init(rating : Double, starCount : Int = ratingStarCount, maxValue : Double = maxRatingValue) {
        self.rating = rating
        self.maxValue = maxValue
        self.starCount = starCount
        
        if rating > maxValue {
            self.rating = maxValue
        }
    }
}
