//
//  RootCoordinator.swift
//  FennecFox
//
//  Created by student on 03.06.2022.
//

import Foundation
import UIKit

class RootController {
    var dataContainer : ColorLabelContainer
    
    var listViewController : ListViewController
    var listViewModel : ListViewModel
    
    var statisticViewController : StatisticViewController
    var statisticViewModel : StatisticViewModel
    
    var navigationController : UINavigationController
    var tabBarController : UITabBarController
    
    init(_ tabBar : UITabBarController){
        // create data container
        dataContainer = ColorLabelContainer()
        dataContainer.generateRandomNumberOfElements()
        
        // add view controllers to tabbar
        tabBarController = tabBar
        
        // create navigation controller
        navigationController = tabBarController.viewControllers?[0] as! UINavigationController
        
        // config list view controller
        listViewController = navigationController.viewControllers[0] as! ListViewController //storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listViewModel = ListViewModel(dataContainer)
        listViewController.viewModel = listViewModel
        
        // config statistic view controller
        statisticViewController = tabBarController.viewControllers?[1] as! StatisticViewController //storyboard.instantiateViewController(withIdentifier: "StatisticViewController") as! StatisticViewController
        statisticViewModel = StatisticViewModel(dataContainer)
        statisticViewController.viewModel = statisticViewModel
    }
    
    func rootController() -> UITabBarController {
        return tabBarController
    }
}
