//
//  File.swift
//  RestaurantNavigator
//
//  Created by student on 09.06.2022.
//

import Foundation
import UIKit

class RestaurantPageViewModel: RemoteDataServiceDelegate {
    var currentRestaurant : Restaurant?
    var restaurantReviews : [Review]
    
    var displayDelegate : RestaurantPageViewModelDisplayDelegate?
    var remoteDataService : RestaurantPageRemoteDataService?
    var bookmarkDataService : RestaurantPageBookmarkDataService?
    
    init(restaurant : Restaurant) {
        currentRestaurant = restaurant
        restaurantReviews = restaurant.reviews
    }
    
    func restaurantInfo() -> (title : String, description : String, photo : UIImage, address : String) {
        guard let restaurant = currentRestaurant else {
            return (title : "", description : "", photo : UIImage(), address :"")
        }
        return (title: restaurant.title, description: restaurant.description, photo: restaurant.gallery.isEmpty ? UIImage() : restaurant.gallery[0], address : restaurant.address)
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
    
    func addNewReview(author : String, text : String) {
        guard let id = currentRestaurant?.id, var dataService = remoteDataService else {
            return
        }
        
        dataService.reviewDelegate = self
        
        let currentDate  = String(describing: NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970))
        dataService.addNewReview(author: author, text: text, restaurantId : id, date : currentDate)
        restaurantReviews.append(Review(author: author, reviewText: text, date: currentDate))
        displayDelegate?.reviewDidLoad()
    }
    
    func bookmarkRestaurant() {
        guard let restaurant = currentRestaurant else {
            return
        }
        if !isBookmarked() {
            bookmarkDataService?.bookmarkRestaurant(restaurantInfo: (title: restaurant.title, id: restaurant.id, description: restaurant.description, address: restaurant.address))
        } else {
            bookmarkDataService?.unbookmarkRestaurant(id: restaurant.id)
        }
    }
    
    func dataDidLoad() {
        displayDelegate?.reviewDidLoad()
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

protocol RestaurantPageViewModelDisplayDelegate {
    func reviewDidLoad()
}

protocol RestaurantPageRemoteDataService {
    var reviewDelegate : RemoteDataServiceDelegate? {get set}
    func addNewReview(author : String, text : String, restaurantId : Int, date : String)
}

protocol RestaurantPageBookmarkDataService {
    func isBookmarked(id : Int) -> Bool
    func bookmarkRestaurant(restaurantInfo : (title : String, id : Int, description : String, address : String))
    func unbookmarkRestaurant(id : Int)
}
