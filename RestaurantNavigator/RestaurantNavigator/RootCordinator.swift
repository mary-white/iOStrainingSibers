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
    
    init() {
        tabBarController = UITabBarController()
        
        bookmarkedRestaurantCoordinator = BookmarkedRestaurantCoordinator()
        remoteRestaurantCoordinator = RemoteRestaurantCoordinator()
        mapCoordinator = MapCoordinator()
        
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
