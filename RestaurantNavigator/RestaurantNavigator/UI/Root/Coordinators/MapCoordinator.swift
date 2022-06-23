//
//  MapCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class MapCoordinator : Coordinator, MapViewModelActionDelegate {
    let navigationController : UINavigationController
    
    let dataContainer : RestaurantContainer
    
    let remoteDataService : RemoteDataService
    let bookmarkDataService : BookmarkDataService
    
    init(dataContainer : RestaurantContainer, remoteDataService : RemoteDataService, bookmarkDataService : BookmarkDataService) {
        navigationController = UINavigationController()
        
        self.dataContainer = dataContainer
        self.remoteDataService = remoteDataService
        self.bookmarkDataService = bookmarkDataService
        
        let viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        let viewModel = MapViewModel()
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        viewModel.dataContainer = dataContainer
        viewController.viewModel = viewModel
        self.remoteDataService.delegate = viewModel
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        
        let restaurantPageViewModel = RestaurantPageViewModel(restaurant: restaurant, reviews: dataContainer.reviews(for: restaurant.id))
        restaurantPageViewModel.remoteDataService = remoteDataService
        restaurantPageViewModel.bookmarkDataService = bookmarkDataService
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
}
