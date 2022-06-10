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
        reviewsTable?.delegate = self
        reviewsTable?.dataSource = self
        
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
extension RestaurantPageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewmodel = viewModel else {
            return 0
        }
        return viewmodel.reviewsCount
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
        // Cell content
        let review = viewModel?.review(at: indexPath.row)
        cell.author?.text = review?.author
        cell.date?.text = review?.date
        cell.reviewText?.text = review?.reviewText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellMarginSize : CGFloat  = 4.0
       // Choose an appropriate default cell size.
       var cellSize = UITableView.automaticDimension
            
       // The first cell is always a title cell. Other cells use the Basic style.
       if indexPath.row == 0 {
          //Title cells consist of one large title row and two body text rows.
          let largeTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
          let bodyFont = UIFont.preferredFont(forTextStyle: .body)
                
          // Get the height of a single line of text in each font.
          let largeTitleHeight = largeTitleFont.lineHeight + largeTitleFont.leading
          let bodyHeight = bodyFont.lineHeight + bodyFont.leading
                
          // Sum the line heights plus top and bottom margins to get the final height.
          let titleCellSize = largeTitleHeight + (bodyHeight * 2.0) + (cellMarginSize * 2)

          // Update the estimated cell size.
          cellSize = titleCellSize
       }
            
       return cellSize
    }
}
