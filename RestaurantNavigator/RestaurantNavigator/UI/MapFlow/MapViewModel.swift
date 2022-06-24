//
//  MapViewModel.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import MapKit

extension Restaurant : MKAnnotation {
    var subtitle: String? {
        get {
            return restaurantDescription
        }
        set {
            restaurantDescription = newValue ?? ""
        }
    }
}

class MapViewModel : RemoteDataServiceDelegate {
    var dataContainer : DataContainerToRead?
    var actionDelegate : MapViewModelActionDelegate?
    weak var displayDelegate : MapViewModelDisplayDelegate?
    
    func restaurantAnnotations() -> [Restaurant] {
        return dataContainer?.restaurantsInfo() ?? []
    }
    
    func showRestaurantPage(id : Int) {
        guard let restaurant = dataContainer?.element(id: id) else {
            return
        }
        actionDelegate?.willShow(restaurant: restaurant)
    }
    
    // protocol function
    func dataDidLoad() {
        displayDelegate?.dataDidLoad(annotations: restaurantAnnotations())
    }
}

protocol MapViewModelActionDelegate : AnyObject {
    func willShow(restaurant : Restaurant)
}

protocol MapViewModelDisplayDelegate : AnyObject {
    func dataDidLoad(annotations: [Restaurant])
}
