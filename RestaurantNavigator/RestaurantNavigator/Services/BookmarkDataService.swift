//
//  BookmarkDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation

class BookmarkDataService : DataService, RestaurantPageBookmarkDataService {
    var dataContainer: RestaurantContainer = RestaurantContainer()
    
    func updateRestaurantData(afterUpdate : @escaping () -> Void) {
        dataContainer.removeAll()
        guard let bookmarkedRestaurants = UserDefaults.standard.object(forKey: "BookmarkedRestaurants") as? [[String : String]] else {
            return
        }
        
        for restaurant in bookmarkedRestaurants {
            guard let title = restaurant["title"], let address = restaurant["address"], let description = restaurant["description"], let id_str = restaurant["id"] else {
                continue
            }
            dataContainer.addRestaurant(title: title, address: address, description: description, id: Int(id_str) ?? 0)
        }
        afterUpdate()
    }
    
    func saveRestaurantData() {
        var dataToSave : [[String:String]] = []
        for restaurant in dataContainer.shortRestaurantInfo() {
            dataToSave.append(["title" : restaurant.title, "address" : restaurant.address, "description" : restaurant.description, "id" : String(restaurant.id)])
        }
        UserDefaults.standard.set(dataToSave, forKey: "BookmarkedRestaurants")
    }
    
    // protocol function
    func isBookmarked(id : Int) -> Bool {
        return dataContainer.container.contains(where: {element in element.id == id})
    }
    
    func bookmarkRestaurant(restaurantInfo: ShortRestaurantInfo) {
        dataContainer.addRestaurant(title: restaurantInfo.title, address: restaurantInfo.address, description: restaurantInfo.description, id: restaurantInfo.id)
        saveRestaurantData()
    }
    
    func unbookmarkRestaurant(id: Int) {
        dataContainer.remove(id: id)
        saveRestaurantData()
    }
}
