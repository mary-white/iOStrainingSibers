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
    
    init() {
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        
        viewModel = RestaurantListViewModel()
        viewModel.dataService = RemoteDataService()
        viewController.viewModel = viewModel
    }
    
    func rootViewController() -> UIViewController {
        return viewController
    }
}
