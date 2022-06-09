//
//  BookmarkedRestaurantCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class BookmarkedRestaurantCoordinator : Coordinator {
    let viewController : RestaurantListViewController
    let viewModel : RestaurantListViewModel
    
    init(dataContainer : RestaurantContainer) {
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RestaurantListViewController") as! RestaurantListViewController
        
        viewModel = RestaurantListViewModel()
        viewModel.dataContainer = dataContainer
        viewModel.dataService = BookmarkDataService()
        viewController.viewModel = viewModel
    }
    
    func rootViewController() -> UIViewController {
        return viewController
    }
}
