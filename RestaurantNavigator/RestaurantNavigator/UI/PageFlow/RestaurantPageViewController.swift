//
//  RestaurantPageViewController.swift
//  RestaurantNavigator
//
//  Created by student on 09.06.2022.
//

import UIKit

class RestaurantPageViewController: UIViewController {
    
    let bookmarkedRestaurantSymbol = "\u{2764}"
    let unbookmarkedRestaurantSumbol = "\u{1F494}"
    
    @IBOutlet var tableHeaderView : UIView?
    @IBOutlet var tableFooterView : UIView?
    
    @IBOutlet var restaurantImage : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantAddress : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
    @IBOutlet var photoGallery : UICollectionView?
    @IBOutlet var reviewsTable : UITableView?
    @IBOutlet var buttonToAddReview : UIButton?
    @IBOutlet var buttonToBookmarkRestaurant : UIButton?
    
    var viewModel : RestaurantPageViewModel?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let tableHeaderView = tableHeaderView, let tableFooterView = tableFooterView, let reviewsTable = reviewsTable else {
            return
        }

        let currentHeaderSize = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height // tableHeaderView.sizeThatFits(CGSize(width: reviewsTable.frame.width, height: CGFloat.infinity)).height //
        tableHeaderView.frame = CGRect(x:0, y:0, width:reviewsTable.frame.width, height:currentHeaderSize)

        let currentFooterSize = tableFooterView.sizeThatFits(CGSize(width: reviewsTable.frame.height, height: CGFloat.infinity))
        tableFooterView.frame = CGRect(x:0, y:0, width:currentFooterSize.width, height:currentFooterSize.height)
        
        reviewsTable.tableHeaderView = tableHeaderView
        reviewsTable.tableFooterView = tableFooterView
        reviewsTable.updateConstraintsIfNeeded()
        reviewsTable.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewsTable?.delegate = self
        reviewsTable?.dataSource = self
        
        // tune restaurant info
        guard let restaurantInfo = viewModel?.restaurantInfo() else {
            return
        }
        
        restaurantImage?.image = restaurantInfo.photo
        restaurantTitle?.text = restaurantInfo.title
        restaurantAddress?.text = restaurantInfo.address
        restaurantDescription?.text = restaurantInfo.description
        
        // tune gallery
        photoGallery?.delegate = self
        photoGallery?.dataSource = self
        
        // tune bookmark button
        updateBookmarkButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateBookmarkButtonState()
    }
    
    @IBAction func addNewReview() {
        if !(viewModel?.canAddComment() ?? false) {
            return
        }
        
        let defaultTextInNametextFeild = "Your name"
        let defaultTextInReviewTextField = "Review text"
        
        let alert = UIAlertController(title: "To add new review", message: "Enter a review text", preferredStyle: .alert)

        alert.addTextField { (textField) in textField.text = defaultTextInNametextFeild }
        alert.addTextField { (textField) in textField.text = defaultTextInReviewTextField }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let alert = alert, let textFields = alert.textFields, let author = textFields[0].text, let text = textFields[1].text else {
                return
            }
            if author == defaultTextInNametextFeild || text == defaultTextInReviewTextField {
                return
            }
            
            self.viewModel?.addNewReview(author: author, text: text) {
                self.reviewsTable?.reloadData()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func bookmarkRestaurant() {
        viewModel?.bookmarkRestaurant()
        updateBookmarkButtonState()
    }
    
    func updateBookmarkButtonState() {
        let bookmarkStateSymbol = viewModel?.isBookmarked() ?? false ? bookmarkedRestaurantSymbol : unbookmarkedRestaurantSumbol
        buttonToBookmarkRestaurant?.setTitle(bookmarkStateSymbol, for: .normal)
    }
}

// review table
class ReviewCell : UITableViewCell {
    @IBOutlet var author : UILabel?
    @IBOutlet var date : UILabel?
    @IBOutlet var reviewText : UILabel?
}

extension RestaurantPageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.reviewsCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            
        // Cell content
        let review = viewModel?.review(at: indexPath.row)
        
        cell.author?.text = review?.author
        cell.date?.text = review?.date
        cell.reviewText?.text = review?.text
        
        return cell
    }
}

// gallery
class RestaurantPhotoCell : UICollectionViewCell {
    @IBOutlet var photo : UIImageView?
}

extension RestaurantPageViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantPhotoCell", for: indexPath) as! RestaurantPhotoCell
        
        cell.photo?.image = viewModel?.photoFromGalery(at: indexPath.row)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        restaurantImage?.image = viewModel?.photoFromGalery(at: indexPath.row)
    }
}
