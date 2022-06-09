//
//  RemoteRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RemoteRestaurantCoordinator : Coordinator, ActionRestaurantListViewModelDelegate {
    let navigationController : UINavigationController
    
    let viewController : RestaurantListViewController
    let viewModel : RestaurantListViewModel
    
    init(dataContainer : RestaurantContainer) {
        navigationController = UINavigationController()
        
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        viewController.title = "Restaurant list"
        
        viewModel = RestaurantListViewModel()
        viewModel.dataService = RemoteDataService()
        viewModel.dataService?.dataContainer = dataContainer
        viewModel.dataContainer = dataContainer
        viewModel.displayDelegate = viewController
        
        viewController.viewModel = viewModel
        viewController.viewModel?.actionDelegate = self
        viewController.viewModel?.dataService?.delegate = viewModel
        viewController.viewModel?.dataService?.updateRestaurantData()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        let restaurantPageViewModel = RestaurantPageViewModel()
        restaurantPageViewModel.currentRestaurant = restaurant
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
}
