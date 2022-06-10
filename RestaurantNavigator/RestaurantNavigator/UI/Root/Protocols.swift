//
//  Protocols.swift
//  RestaurantNavigator
//
//  Created by student on 10.06.2022.
//

import Foundation

protocol DataService : AnyObject {
    var delegate : RemoteDataServiceDelegate? { get set }
    var dataContainer : RestaurantContainer { get set }
    func updateRestaurantData()
}

protocol DataContainerToRead {
    func restaurantCoordinatsList() -> [(title : String, id : Int, latitudinal : Double, longitudinal : Double)]
    func element(at_id id : Int) -> Restaurant?
}
