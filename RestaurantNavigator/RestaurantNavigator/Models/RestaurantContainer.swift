//
//  Restaurant.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit
import CoreLocation

struct Review {
    let author: String
    let reviewText : String
    let date: String
}

class Restaurant : NSObject {
    var id : Int
    var title : String?
    var address : String
    var restaurantDescription : String
    var gallery : [UIImage] = []
    var rating : Double = 0

    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var image : UIImage {
        get {
            if gallery.isEmpty {
                return UIImage()
            }
            return gallery[0]
        }
        set {
            gallery = [newValue]
        }
    }
    
    init(id: Int, title: String, address: String, description: String) {
        self.id = id
        self.title = title
        self.address = address
        self.restaurantDescription = description
    }
    
    convenience override init() {
        self.init(id: 0, title: "", address: "", description: "")
    }
}

struct ShortRestaurantInfo {
    var id : Int
    var title : String
    var address : String
    var description : String
}

class RestaurantContainer : DataContainerToRead {
    var container : Array<Restaurant> = []
    var reviewContainer : [Int : [Review]] = [:]
    
    var count : Int {
        return container.count
    }
    
    func addRestaurant(title : String, address : String, description : String, id : Int) {
        container.append(Restaurant(id: id, title: title, address: address, description: description))
    }
    
    subscript(index : Int) -> Restaurant? {
        if index >= container.count || index < 0 {
            return nil
        }
        return container[index]
    }
    
    func removeAll() {
        container.removeAll()
    }
    
    func remove(id : Int) {
        guard let index = container.firstIndex(where: {element in element.id == id}) else {
            return
        }
        container.remove(at: index)
    }
    
    func addImageToGalery(for id : Int, newImage : UIImage) {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].gallery.append(newImage)
    }
    
    func addReview(for id : Int, newReview : Review) {
        if reviewContainer[id] == nil {
            reviewContainer[id] = [newReview]
        } else {
            reviewContainer[id]?.append(newReview)
        }
    }
    
    func setRaiting(for id : Int, rating : Double) {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].rating = rating
    }
    
    func reviews(for id : Int) -> [Review] {
        return reviewContainer[id] ?? []
    }
    
    func removeAllReviews() {
        reviewContainer.removeAll()
    }
    
    func setRestaurantCoordinats(lat : Double, lon : Double, for id : Int) {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func shortRestaurantInfo() -> [ShortRestaurantInfo] {
        var result : [ShortRestaurantInfo] = []
        for restaurant in container {
            result.append(ShortRestaurantInfo(id: restaurant.id, title: restaurant.title ?? "", address: restaurant.address, description: restaurant.restaurantDescription))
        }
        return result
    }
    
    // protocol functions
    func restaurantsInfo() -> [Restaurant] {
        return container
    }
    
    func element(id : Int) -> Restaurant? {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return nil
        }
        
        return container[index]
    }
}
