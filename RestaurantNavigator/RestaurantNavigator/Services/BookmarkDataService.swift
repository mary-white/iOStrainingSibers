//
//  BookmarkDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation

class BookmarkDataService : DataService {
    weak var delegate: RemoteDataServiceDelegate?
    
    var dataContainer: RestaurantContainer = RestaurantContainer()
    
    func updateRestaurantData() {
    }
}
