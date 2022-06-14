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
    
    var displayDelegate : DisplayRestaurantPageViewModelDelegate?
    var dataService : RestaurantPageDataService?
    
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
    
    var photoCount : Int {
        get {
            return currentRestaurant?.galery.count ?? 0
        }
    }
    
    func photoFromGalery(at index : Int) -> UIImage {
        guard let galery = currentRestaurant?.galery else {
            return UIImage()
        }
        if index >= photoCount || index < 0 {
            return UIImage()
        }
        return galery[index]
    }
    
    func addNewReview(author : String, text : String) {
        guard let id = currentRestaurant?.id, var dataService = dataService else {
            return
        }
        
        dataService.reviewDelegate = self
        
        dataService.addNewReview(author: author, text: text, restaurantId : id, date : String(describing: NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970)))
    }
    
    func dataDidLoad() {
        displayDelegate?.reviewDidLoad()
    }
}

protocol DisplayRestaurantPageViewModelDelegate {
    func reviewDidLoad()
}

protocol RestaurantPageDataService {
    var reviewDelegate : RemoteDataServiceDelegate? {get set}
    func addNewReview(author : String, text : String, restaurantId : Int, date : String)
}
