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
    var reviews : [Review] = []

    var location : CLLocationCoordinate2D = CLLocationCoordinate2D()
}

class RestaurantContainer : DataContainerToRead {
    var container : Array<Restaurant> = []
    
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
    func restaurantsInfo() -> [(title: String, id : Int, latitudinal: Double, longitudinal: Double, description : String, image : UIImage, address : String)] {
        var result : [(title: String, id : Int, latitudinal: Double, longitudinal: Double, description : String, image : UIImage, address : String)] = []
        for restaurant in container {
            let location = restaurant.location
            var image : UIImage = UIImage()
            if !restaurant.gallery.isEmpty {
                image = restaurant.gallery[0]
            }
            result.append((title: restaurant.title, id : restaurant.id, latitudinal: location.latitude, longitudinal: location.longitude, description : restaurant.description, image : image, address : restaurant.address))
        }
        return result
    }
    
    func element(id : Int) -> Restaurant? {
        guard let index = container.firstIndex(where: {(el : Restaurant) in return el.id == id} ) else {
            return nil
        }
        
        return container[index]
    }
}
