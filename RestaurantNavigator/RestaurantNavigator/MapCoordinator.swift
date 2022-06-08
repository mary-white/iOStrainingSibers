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
    
    init() {
        viewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        viewModel = MapViewModel()
        viewController.viewModel = viewModel
    }
    
    func rootViewController() -> UIViewController {
        return viewController
    }
}
