//
//  RemoteRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RemoteRestaurantCoordinator : Coordinator, ActionRestaurantListViewModelDelegate, ActionRestaurantPageViewModelDelegate {
    let navigationController : UINavigationController
    
    let viewController : RestaurantListViewController
    let viewModel : RestaurantListViewModel
    
    let dataService : RemoteDataService
    
    init(dataContainer : RestaurantContainer) {
        navigationController = UINavigationController()
        
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        viewController.title = "Restaurant list"
        
        dataService = RemoteDataService()
        dataService.dataContainer = dataContainer
        
        viewModel = RestaurantListViewModel()
        viewModel.dataService = dataService
        viewModel.dataContainer = dataContainer
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        
        viewController.viewModel = viewModel
        viewController.viewModel?.dataService?.delegate = viewModel
        viewController.viewModel?.dataService?.updateRestaurantData()
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func rootViewController() -> UIViewController {
        return navigationController
    }
    
    func willShow(restaurant: Restaurant) {
        let restaurantPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantPageViewController") as! RestaurantPageViewController
        let restaurantPageViewModel = RestaurantPageViewModel(restaurant: restaurant)
        restaurantPageViewModel.displayDelegate = restaurantPageViewController
        restaurantPageViewModel.actionDelegate = self
        restaurantPageViewController.viewModel = restaurantPageViewModel
        
        navigationController.pushViewController(restaurantPageViewController, animated: true)
    }
    
    func addNewReview(author : String, text : String, restaurantId : Int, date : String) {
        dataService.addReview(author : author, text : text, restaurantId : restaurantId, date : date)
        dataService.updateRestaurantData()
    }
}
