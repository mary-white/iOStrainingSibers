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
    func restaurantsInfo() -> [(title : String, id : Int, latitudinal : Double, longitudinal : Double, description : String, image : UIImage, address : String)]
    func element(id : Int) -> Restaurant?
}
