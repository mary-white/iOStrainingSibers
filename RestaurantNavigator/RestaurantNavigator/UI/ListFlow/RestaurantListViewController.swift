//
//  ViewController.swift
//  RestaurantNavigator
//
//  Created by student on 06.06.2022.
//

import UIKit

class RestaurantListViewController: UIViewController, RestaurantListViewModelDisplayDelegate {

    @IBOutlet var restaurantTable : UITableView?
    
    var viewModel : RestaurantListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTable?.delegate = self
        restaurantTable?.dataSource = self
        
        restaurantTable?.refreshControl = UIRefreshControl()
        restaurantTable?.refreshControl?.addTarget(self, action: #selector(updateRestaurantListInfo), for: .valueChanged)
        
        restaurantTable?.refreshControl?.tintColor = .systemMint
        restaurantTable?.refreshControl?.attributedTitle = NSAttributedString(string: "Update restaurant data")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restaurantTable?.reloadData()
    }
    
    func dataDidLoad() {
        restaurantTable?.reloadData()
    }
    
    @objc func updateRestaurantListInfo() {
        viewModel?.updateRestaurantListInfo()
        
        DispatchQueue.main.async {
            self.restaurantTable?.reloadData()
            self.restaurantTable?.refreshControl?.endRefreshing()
        }
    }
}

class RestaurantCell : UITableViewCell {
    @IBOutlet var restaurantImage : UIImageView?
    @IBOutlet var restaurantTitle : UILabel?
    @IBOutlet var restaurantDescription : UILabel?
}

extension RestaurantListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.containerCount ?? 0
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
            
        // Cell content
        guard let element = viewModel?.containerElement(at: indexPath.row) else {
            return cell
        }
        
        cell.restaurantTitle?.text = element.title
        cell.restaurantDescription?.text = element.description
        cell.restaurantImage?.image = element.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.showRestaurantPage(at : indexPath.row)
    }
}

