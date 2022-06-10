//
//  MapViewController.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapBox : MKMapView?
    
    var viewModel : MapViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
