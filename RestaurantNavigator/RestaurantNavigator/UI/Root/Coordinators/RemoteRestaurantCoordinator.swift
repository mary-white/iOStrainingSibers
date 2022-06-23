//
//  RemoteRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RemoteRestaurantCoordinator : Coordinator, RestaurantListViewModelActionDelegate {
    let navigationController : UINavigationController
    
    let viewController : RestaurantListViewController
    let viewModel : RestaurantListViewModel
    
    let remoteDataService : RemoteDataService
    let bookmarkDataService : BookmarkDataService
    
    init(dataContainer : RestaurantContainer, remoteDataService : RemoteDataService, bookmarkDataService : BookmarkDataService) {
        navigationController = UINavigationController()
        
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        viewController.title = "Restaurant list"
        
        self.remoteDataService = remoteDataService
        self.bookmarkDataService = bookmarkDataService
        
        viewModel = RestaurantListViewModel()
        viewModel.dataService = remoteDataService
        viewModel.dataContainer = dataContainer
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(_ viewModel : RestaurantListViewModel, restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        let restaurantPageViewModel = RestaurantPageViewModel(restaurant: restaurant, reviews: viewModel.dataContainer?.reviews(for: restaurant.id) ?? [])
        restaurantPageViewModel.remoteDataService = remoteDataService
        restaurantPageViewModel.bookmarkDataService = bookmarkDataService
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
}
