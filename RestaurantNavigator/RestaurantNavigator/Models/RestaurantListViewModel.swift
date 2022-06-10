//
//  RestaurantListViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RestaurantListViewModel : RemoteDataServiceDelegate  {
    var dataService : DataService?
    weak var displayDelegate : DisplayRestaurantListViewModelDelegate?
    var actionDelegate : ActionRestaurantListViewModelDelegate?
    var dataContainer : RestaurantContainer?
    
    var containerCount : Int {
        get {
            return dataContainer?.count ?? 0
        }
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
    
    func showRestaurantPage(at index : Int) {
        guard let currentRestaurant = dataContainer?.element(at: index) else {
            return
        }
        actionDelegate?.willShow(restaurant: currentRestaurant)
    }
    
    // protocol function
    func dataDidLoad() {
        displayDelegate?.dataDidLoad()
    }
}

protocol DisplayRestaurantListViewModelDelegate : AnyObject {
    func dataDidLoad()
}

protocol ActionRestaurantListViewModelDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
