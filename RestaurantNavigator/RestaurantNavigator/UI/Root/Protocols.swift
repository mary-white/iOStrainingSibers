//
//  Protocols.swift
//  RestaurantNavigator
//
//  Created by student on 10.06.2022.
//

import Foundation
import UIKit

protocol DataService : AnyObject {
    var dataContainer : RestaurantContainer { get set }
    func updateRestaurantData(afterUpdate : @escaping () -> Void)
}

protocol DataContainerToRead {
    func restaurantsInfo() -> [Restaurant]
    func element(id : Int) -> Restaurant?
}
