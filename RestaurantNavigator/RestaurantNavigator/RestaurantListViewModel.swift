//
//  RestaurantListViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation

class RestaurantListViewModel  {
    var dataService : DataService?
    var delegate : DisplayRestaurantListViewModelDelegate?
    
    func containerCount() -> Int? {
        return dataService?.containerCount()
    }
    
    func dataDidLoad(loadedData: String) {
        delegate?.dataDidLoad()
    }
}

protocol DataService {
    var delegate : RestaurantListViewModel? { get set }
    func updateDataOfrestaurant()
    
    func containerCount() -> Int // deleteThis
    func containerElement(at index : Int) -> (title : String, description : String)? // deleteThis
}

protocol DisplayRestaurantListViewModelDelegate : AnyObject {
    func dataDidLoad()
}
