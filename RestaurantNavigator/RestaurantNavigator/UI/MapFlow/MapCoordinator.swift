//
//  MapCoordinator.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

class MapCoordinator : Coordinator {
    let viewController : MapViewController
    let viewModel : MapViewModel
    
    init(dataContainer : RestaurantContainer) {
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        viewModel = MapViewModel()
        viewModel.dataContainer = dataContainer
        viewController.viewModel = viewModel
    }
    
    func rootViewController() -> UIViewController {
        return viewController
    }
}
