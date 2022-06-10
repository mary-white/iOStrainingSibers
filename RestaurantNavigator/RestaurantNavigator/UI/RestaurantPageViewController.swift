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
    
    @IBOutlet var restaurantImage : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
    @IBOutlet var reviewsTable : UITableView?
    
    var viewModel : RestaurantPageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTable?.delegate = self
        reviewsTable?.dataSource = self
        
        guard let restaurantInfo = viewModel?.restaurantInfo() else {
            return
        }
        
        let images = restaurantInfo.gallery
        if !images.isEmpty {
            restaurantImage?.image = images[0]
        }
        
        restaurantTitle?.text = restaurantInfo.title
        restaurantDescription?.text = restaurantInfo.description
    }
}

extension RestaurantPageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.reviewsCount ?? 0
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
        // Cell content
        let review = viewModel?.review(at: indexPath.row)
        
        cell.author?.text = review?.author
        cell.date?.text = review?.date
        cell.reviewText?.text = review?.text
        
        return cell
    }
}
