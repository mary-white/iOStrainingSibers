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

class RestaurantListViewController: UIViewController, DisplayRestaurantListViewModelDelegate {

    @IBOutlet var restaurantTable : UITableView?
    
    var viewModel : RestaurantListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTable?.delegate = self
        restaurantTable?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restaurantTable?.reloadData()
    }
    
    func dataDidLoad() {
        restaurantTable?.reloadData()
    }
}

extension RestaurantListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.containerCount ?? 0
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
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

