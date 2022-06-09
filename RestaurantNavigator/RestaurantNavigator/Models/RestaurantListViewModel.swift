//
//  RestaurantListViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RestaurantListViewModel  {
    var dataService : DataService?
    var displayDelegate : DisplayRestaurantListViewModelDelegate?
    var actionDelegate : ActionRestaurantListViewModelDelegate?
    var dataContainer : RestaurantContainer?
    
    func containerCount() -> Int? {
        return dataContainer?.count
    }
    
    func containerElement(at index : Int) -> (title : String, description : String, image : UIImage) {
        guard let element = dataContainer?.element(at: index) else {
            return (title : "", description : "", image : UIImage())
        }
        var image = UIImage()
        if !element.galery.isEmpty {
            image = element.galery[0]
        }
        return (title : element.title, description : element.description, image : image)
    }
    
    func dataDidLoad() {
        displayDelegate?.dataDidLoad()
    }
    
    func showRestaurantPage(_ index : Int) {
        guard let currentRestaurant = dataContainer?.element(at: index) else {
            return
        }
        actionDelegate?.willShow(restaurant: currentRestaurant)
    }
}

protocol DataService {
    var delegate : RestaurantListViewModel? { get set }
    var dataContainer : RestaurantContainer { get set }
    func updateRestaurantData()
}

protocol DisplayRestaurantListViewModelDelegate : AnyObject {
    func dataDidLoad()
}

protocol ActionRestaurantListViewModelDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
