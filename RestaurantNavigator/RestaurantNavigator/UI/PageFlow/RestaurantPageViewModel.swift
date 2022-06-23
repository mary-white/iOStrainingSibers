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
    
    var remoteDataService : RestaurantPageRemoteDataService?
    var bookmarkDataService : RestaurantPageBookmarkDataService?
    
    init(restaurant : Restaurant, reviews : [Review]) {
        currentRestaurant = restaurant
        restaurantReviews = reviews
    }
    
    func restaurantInfo() -> RestaurantInfoViewModel {
        guard let restaurant = currentRestaurant else {
            return RestaurantInfoViewModel()
        }
        return RestaurantInfoViewModel(restaurant: restaurant)
    }
    
    var reviewsCount: Int {
        return restaurantReviews.count
    }
    
    func review(at index : Int) -> (author : String,  date : String, text : String) {
        let review = restaurantReviews[index]
        return (author : review.author, date : review.date, text : review.reviewText)
    }
    
    var photoCount : Int {
        return currentRestaurant?.gallery.count ?? 0
    }
    
    func photoFromGalery(at index : Int) -> UIImage {
        guard let gallery = currentRestaurant?.gallery else {
            return UIImage()
        }
        if index >= photoCount || index < 0 {
            return UIImage()
        }
        return gallery[index]
    }
    
    func addNewReview(author : String, text : String, afterAdd : @escaping () -> Void) {
        guard let id = currentRestaurant?.id, let dataService = remoteDataService else {
            return
        }
        
        let currentDate  = String(describing: NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970))
        dataService.addNewReview(author: author, text: text, restaurantId : id, date : currentDate)
        restaurantReviews.append(Review(author: author, reviewText: text, date: currentDate))
        afterAdd()
    }
    
    func bookmarkRestaurant() {
        guard let restaurant = currentRestaurant else {
            return
        }
        if !isBookmarked() {
            bookmarkDataService?.bookmarkRestaurant(restaurantInfo: ShortRestaurantInfo(id: restaurant.id, title: restaurant.title ?? "", address: restaurant.address, description: restaurant.restaurantDescription))
        } else {
            bookmarkDataService?.unbookmarkRestaurant(id: restaurant.id)
        }
    }
    
    func isBookmarked() -> Bool {
        guard let restaurantId = currentRestaurant?.id else {
            return false
        }
        return bookmarkDataService?.isBookmarked(id: restaurantId) ?? false
    }
    
    func canAddComment() -> Bool {
        return remoteDataService != nil
    }
}

protocol RestaurantPageRemoteDataService {
    func addNewReview(author : String, text : String, restaurantId : Int, date : String)
}

protocol RestaurantPageBookmarkDataService {
    func isBookmarked(id : Int) -> Bool
    func bookmarkRestaurant(restaurantInfo : ShortRestaurantInfo)
    func unbookmarkRestaurant(id : Int)
}

protocol RestaurantPageInfoViewModelProtocol {
    var title : String {get set}
    var description : String {get set}
    var image : UIImage {get set}
    var address : String {get set}
}
