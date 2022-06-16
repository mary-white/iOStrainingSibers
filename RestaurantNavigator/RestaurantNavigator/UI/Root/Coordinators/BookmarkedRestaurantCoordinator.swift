//
//  BookmarkedRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class BookmarkedRestaurantCoordinator : Coordinator, ActionRestaurantListViewModelDelegate {
    let navigationController : UINavigationController
    
    let viewController : RestaurantListViewController
    let viewModel : RestaurantListViewModel
    
    let bookmarkDataService : BookmarkDataService
    
    init(dataContainer : RestaurantContainer, bookmarkDataService : BookmarkDataService) {
        navigationController = UINavigationController()
        
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        
        viewModel = RestaurantListViewModel()
        
        self.bookmarkDataService = bookmarkDataService
        
        viewModel.dataContainer = dataContainer
        viewModel.dataService?.updateRestaurantData()
        viewModel.actionDelegate = self
        
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        let restaurantPageViewModel = RestaurantPageViewModel(restaurant: restaurant)
        restaurantPageViewModel.displayDelegate = restaurantPageViewController
        restaurantPageViewModel.bookmarkDataService = bookmarkDataService
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
}