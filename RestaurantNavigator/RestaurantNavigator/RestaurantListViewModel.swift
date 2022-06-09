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
    var dataContainer : RestaurantContainer?
    
    func containerCount() -> Int? {
        return dataContainer?.count
    }
    
    func containerElement(at index : Int) -> (title : String, description : String) {
        guard let element = dataContainer?.element(at: index) else {
            return (title : "", description : "")
        }
        return (title : element.title, description : element.description)
    }
    
    func dataDidLoad(loadedData: String) {
        delegate?.dataDidLoad()
    }
}

protocol DataService {
    var delegate : RestaurantListViewModel? { get set }
    var dataContainer : RestaurantContainer { get set }
    func updateDataOfrestaurant()
}

protocol DisplayRestaurantListViewModelDelegate : AnyObject {
    func dataDidLoad()
}
