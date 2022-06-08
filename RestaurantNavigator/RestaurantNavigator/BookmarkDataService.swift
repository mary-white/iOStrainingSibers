//
//  BookmarkDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation

class BookmarkDataService : DataService {
    func updateDataOfrestaurant() {
    }
    
    var delegate: RestaurantListViewModel?
    
    func containerElement(at index: Int) -> (title: String, description: String)? {
        return nil
    }
    
    func containerCount() -> Int {
        return 0
    }
    
    
}
