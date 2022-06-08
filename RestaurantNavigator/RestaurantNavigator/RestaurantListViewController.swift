//
//  ViewController.swift
//  RestaurantNavigator
//
//  Created by student on 06.06.2022.
//

import UIKit

class RestaurantCell : UITableViewCell {
    @IBOutlet var restaurantImage : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
}

class RestaurantListViewController: UIViewController {

    @IBOutlet var table : UITableView?
    
    var viewModel : RestaurantListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

