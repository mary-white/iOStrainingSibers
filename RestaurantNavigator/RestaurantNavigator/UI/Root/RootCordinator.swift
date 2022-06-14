//
//  RootCordinator.swift
//  RestaurantNavigator
//
//  Created by student on 06.06.2022.
//

import Foundation
import UIKit

class RootCoordinator {
    let tabBarController : UITabBarController
    
    let bookmarkedRestaurantCoordinator : BookmarkedRestaurantCoordinator
    let remoteRestaurantCoordinator : RemoteRestaurantCoordinator
    let mapCoordinator : MapCoordinator
    
    let remoteRestaurantContainer : RestaurantContainer
    let bookmarkedRestaurantContainer : RestaurantContainer
    
    let remoteDataService : RemoteDataService
    let bookmarkDataService : BookmarkDataService
    
    init() {
        tabBarController = UITabBarController()
        
        remoteRestaurantContainer = RestaurantContainer()
        bookmarkedRestaurantContainer = RestaurantContainer()
        
        remoteDataService = RemoteDataService()
        remoteDataService.dataContainer = remoteRestaurantContainer
        
        bookmarkDataService = BookmarkDataService()
        bookmarkDataService.dataContainer = bookmarkedRestaurantContainer
        
        bookmarkedRestaurantCoordinator = BookmarkedRestaurantCoordinator(dataContainer: bookmarkedRestaurantContainer, dataService : bookmarkDataService)
        remoteRestaurantCoordinator = RemoteRestaurantCoordinator(dataContainer: remoteRestaurantContainer, remoteDataService : remoteDataService, bookmarkDataService : bookmarkDataService)
        mapCoordinator = MapCoordinator(dataContainer: remoteRestaurantContainer, remoteDataService : remoteDataService, bookmarkDataService : bookmarkDataService)
        
        let bookmarkedRestaurantViewController = bookmarkedRestaurantCoordinator.rootViewController()
        let remoteRestaurantViewController = remoteRestaurantCoordinator.rootViewController()
        let mapViewController = mapCoordinator.rootViewController()
        
        tabBarController.setViewControllers([remoteRestaurantViewController, mapViewController, bookmarkedRestaurantViewController], animated: true)
        
        tabBarController.viewControllers?[0].title = "All restaurant"
        tabBarController.viewControllers?[1].title = "Map"
        tabBarController.viewControllers?[2].title = "Bookmark"
    }
}

protocol Coordinator : AnyObject {
    func rootViewController() -> UIViewController
}
