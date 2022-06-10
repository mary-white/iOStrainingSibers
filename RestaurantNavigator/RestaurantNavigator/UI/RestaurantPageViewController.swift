//
//  RestaurantPageViewController.swift
//  RestaurantNavigator
//
//  Created by student on 09.06.2022.
//

import UIKit

class ReviewCell : UITableViewCell {
    @IBOutlet var author : UILabel?
    @IBOutlet var date : UILabel?
    @IBOutlet var reviewText : UILabel?
}

class RestaurantPageViewController: UIViewController {
    
    @IBOutlet var image : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
    @IBOutlet var reviewsTable : UITableView?
    
    var viewModel : RestaurantPageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        //reviewsTable?.delegate = self
        
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

// don't show my table
/*extension RestaurantPageViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*guard let viewmodel = viewModel, let count = viewmodel.containerCount() else {
            return 0
        }
        return count*/
        print("call")
        return 3
    }
    
    // fill the table
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
        // Cell content
        /*let element = viewModel?.containerElement(at: indexPath.row)
        cell.restaurantTitle?.text = (element?.title)!
        cell.restaurantDescription?.text = (element?.description)!
        cell.restaurantImage?.image = element?.image*/
        cell.author?.text = "asd"
        cell.date?.text = "sdf"
        cell.reviewText?.text = "sfsf"
        
        return cell
    }
}*/

