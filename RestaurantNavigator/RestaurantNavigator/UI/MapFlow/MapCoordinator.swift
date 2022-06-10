//
//  MapCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class MapCoordinator : Coordinator, ActionMapViewModelDelegate {
    let navigationController : UINavigationController
    
    let viewController : MapViewController
    let viewModel : MapViewModel
    
    init(dataContainer : RestaurantContainer) {
        navigationController = UINavigationController()
        
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        viewModel = MapViewModel()
        viewModel.actionDelegate = self
        viewModel.dataContainer = dataContainer
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        let restaurantPageViewModel = RestaurantPageViewModel(restaurant: restaurant)
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
}
