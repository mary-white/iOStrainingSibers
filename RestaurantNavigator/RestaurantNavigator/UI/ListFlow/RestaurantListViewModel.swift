//
//  RestaurantListViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RestaurantListViewModel {
    var dataService : DataService? {
        didSet {
            dataService?.updateRestaurantData {
                self.displayDelegate?.dataDidLoad()
            }
        }
    }
    weak var displayDelegate : RestaurantListViewModelDisplayDelegate?
    var actionDelegate : RestaurantListViewModelActionDelegate?
    var dataContainer : RestaurantContainer?
    
    var containerCount : Int {
        get {
            return dataContainer?.count ?? 0
        }
    }
    
    func containerElement(at index : Int) -> (title : String, description : String, image : UIImage) {
        guard let element = dataContainer?[index] else {
            return (title : "", description : "", image : UIImage())
        }
        var image = UIImage()
        if !element.gallery.isEmpty {
            image = element.gallery[0]
        }
        return (title : element.title, description : element.description, image : image)
    }
    
    func showRestaurantPage(at index : Int) {
        guard let currentRestaurant = dataContainer?[index] else {
            return
        }
        actionDelegate?.willShow(restaurant: currentRestaurant)
    }
    
    func updateRestaurantListInfo() {
        dataService?.updateRestaurantData() {
            self.displayDelegate?.dataDidLoad()
        }
    }
}

protocol RestaurantListViewModelDisplayDelegate : AnyObject {
    func dataDidLoad()
}

protocol RestaurantListViewModelActionDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}
