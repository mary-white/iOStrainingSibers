//
//  RestaurantPageViewController.swift
//  RestaurantNavigator
//
//  Created by student on 09.06.2022.
//

import UIKit

class RestaurantPageViewController: UIViewController {
    
    @IBOutlet var image : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
    
    var viewModel : RestaurantPageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else {
            return
        }
        
        let restaurantInfo = viewModel.restaurantInfo()
        
        let images = restaurantInfo.gallery
        if images.isEmpty {
            image?.image = UIImage()
        }
        else {
            image?.image = images[0]
        }
        
        restaurantTitle?.text = restaurantInfo.title
        restaurantDescription?.text = restaurantInfo.description
    }
}
