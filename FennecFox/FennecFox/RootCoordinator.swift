//
//  RootCoordinator.swift
//  FennecFox
//
//  Created by student on 03.06.2022.
//

import Foundation
import UIKit

class RootController : ListViewModelDelegate, EditViewModelDelegate {
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
        statisticViewController = tabBarController.viewControllers?[1] as! StatisticViewController
        statisticViewModel = StatisticViewModel(dataContainer)
        statisticViewController.viewModel = statisticViewModel
        
        // set delegates
        listViewController.viewModel?.delegate = self
    }
    
    func willChangeData() {
        // create and configure the new view
        let editViewController = tabBarController.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        let editViewModel : EditViewModel = EditViewModel()
        editViewModel.editingCell = dataContainer.element(at: listViewModel.editingCellNumber!)
        editViewModel.delegate = self
        editViewController.viewModel = editViewModel
        
        navigationController.pushViewController(editViewController, animated: true)
    }
    
    func didChangeData(newData : ColorLabel) {
        listViewController.viewModel?.didChangeData(newData: newData)
        listViewController.didChangeData()
        navigationController.popViewController(animated: true)
    }
}
