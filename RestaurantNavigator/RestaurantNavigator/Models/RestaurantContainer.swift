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

struct Restaurant {
    var id : Int
    var title : String
    var address : String
    var description : String
    var gallery : [UIImage] = []

    var location : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var image : UIImage {
        get {
            if gallery.isEmpty {
                return UIImage()
            }
            return gallery[0]
        }
    }
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
        
        container[index].location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func shortRestaurantInfo() -> [(title: String, id : Int, description : String, address : String)] {
        var result : [(title: String, id : Int, description : String, address : String)] = []
        for restaurant in container {
            result.append((title : restaurant.title, id : restaurant.id, description : restaurant.description, address : restaurant.address))
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
