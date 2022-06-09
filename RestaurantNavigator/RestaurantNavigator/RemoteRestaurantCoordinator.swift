//
//  RemoteRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class RemoteRestaurantCoordinator : Coordinator {
    let viewController : RestaurantListViewController
    let viewModel : RestaurantListViewModel
    
    init(dataContainer : RestaurantContainer) {
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        
        viewModel = RestaurantListViewModel()
        viewModel.dataService = RemoteDataService()
        viewModel.dataService?.dataContainer = dataContainer
        viewModel.dataContainer = dataContainer
        viewModel.delegate = viewController
        
        viewController.viewModel = viewModel
        viewController.viewModel?.dataService?.delegate = viewModel
        viewController.viewModel?.dataService?.updateRestaurantData()
    }
    
    func rootViewController() -> UIViewController {
        return viewController
    }
}
