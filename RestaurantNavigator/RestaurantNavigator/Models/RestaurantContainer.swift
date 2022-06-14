//
//  Restaurant.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

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
    var reviews : [Review] = []

    //var rating : Int?
    var location : (lat : Double, lon : Double) = (lat:0, lon:0)
}

class RestaurantContainer : DataContainerToRead {
    var container : Array<Restaurant> = []
    
    var count : Int {
        get {
            return container.count
        }
    }
    
    func addRestaurant(title : String, address : String, description : String, id : Int) {
        container.append(Restaurant(id: id, title: title, address: address, description: description))
    }
    
    func element(at index : Int) -> Restaurant? {
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
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].reviews.append(newReview)
    }
    
    func setRestaurantCoordinats(lat : Double, lon : Double, for id : Int) {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return
        }
        
        container[index].location = (lat : lat, lon : lon)
    }
    
    func shortRestaurantInfo() -> [(title: String, id : Int, description : String, address : String)] {
        var result : [(title: String, id : Int, description : String, address : String)] = []
        for restaurant in container {
            result.append((title : restaurant.title, id : restaurant.id, description : restaurant.description, address : restaurant.address))
        }
        return result
    }
    
    // protocol functions
    func restaurantInfo() -> [(title: String, id : Int, latitudinal: Double, longitudinal: Double, description : String, image : UIImage, address : String)] {
        var result : [(title: String, id : Int, latitudinal: Double, longitudinal: Double, description : String, image : UIImage, address : String)] = []
        for restaurant in container {
            let location = restaurant.location
            var image : UIImage = UIImage()
            if !restaurant.gallery.isEmpty {
                image = restaurant.gallery[0]
            }
            result.append((title: restaurant.title, id : restaurant.id, latitudinal: location.lat, longitudinal: location.lon, description : restaurant.description, image : image, address : restaurant.address))
        }
        return result
    }
    
    func element(at_id id : Int) -> Restaurant? {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return nil
        }
        
        return container[index]
    }
}
