//
//  BookmarkedRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class BookmarkedRestaurantCoordinator : Coordinator, RestaurantListViewModelActionDelegate {
    let navigationController : UINavigationController
    
    let bookmarkDataService : BookmarkDataService
    
    init(dataContainer : RestaurantContainer, bookmarkDataService : BookmarkDataService) {
        navigationController = UINavigationController()
        
        let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        
        let viewModel = RestaurantListViewModel()
        
        self.bookmarkDataService = bookmarkDataService
        
        viewModel.dataContainer = dataContainer
        viewModel.dataService = bookmarkDataService
        viewModel.actionDelegate = self
        
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(_ viewModel : RestaurantListViewModel, restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        let restaurantPageViewModel = RestaurantPageViewModel(restaurant: restaurant, reviews: [])
        restaurantPageViewModel.bookmarkDataService = bookmarkDataService
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
}
