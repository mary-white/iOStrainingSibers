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

class RestaurantPageViewController: UIViewController, DisplayRestaurantPageViewModelDelegate {
    
    @IBOutlet var tableHeaderView : UIView?
    @IBOutlet var tableFooterView : UIView?
    
    @IBOutlet var restaurantImage : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
    @IBOutlet var reviewsTable : UITableView?
    @IBOutlet var addingReview : UIButton?
    @IBOutlet var photoGalery : UICollectionView?
    @IBOutlet var restaurantAddress : UILabel?
    @IBOutlet var bookmarkingRestaurantButton : UIButton?
    
    var viewModel : RestaurantPageViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTable?.tableHeaderView = tableHeaderView
        reviewsTable?.tableFooterView = tableFooterView
        
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
        restaurantAddress?.text = restaurantInfo.address
        
        photoGalery?.delegate = self
        photoGalery?.dataSource = self
        
        if viewModel?.isBookmark() ?? false {
            bookmarkingRestaurantButton?.setTitle("\u{2764}", for: .normal)
        }
        else {
            bookmarkingRestaurantButton?.setTitle("\u{1F494}", for: .normal)
        }
    }
    
    @IBAction func addNewReview() {
        let defaultTextInNametextFeild = "Your name"
        let defaultTestInReviewTextField = "Review text"
        
        let alert = UIAlertController(title: "To add new review", message: "Enter a review text", preferredStyle: .alert)

        alert.addTextField { (textField) in textField.text = defaultTextInNametextFeild }
        alert.addTextField { (textField) in textField.text = defaultTestInReviewTextField }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let alert = alert, let textFields = alert.textFields, let author = textFields[0].text, let text = textFields[1].text else {
                return
            }
            if author == defaultTextInNametextFeild || text == defaultTestInReviewTextField {
                return
            }
            
            self.viewModel?.addNewReview(author: author, text: text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func bookmarkRestaurant() {
        viewModel?.bookmarkRestaurant()
        
        if viewModel?.isBookmark() ?? false {
            bookmarkingRestaurantButton?.setTitle("\u{2764}", for: .normal)
        }
        else {
            bookmarkingRestaurantButton?.setTitle("\u{1F494}", for: .normal)
        }
    }
    
    // protocol function
    func reviewDidLoad() {
        reviewsTable?.reloadData()
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
        cell.backgroundColor = .white

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RestaurantPhotoCell {
            restaurantImage?.image = cell.photo?.image
        }
    }
}
