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

    @IBOutlet var table : UITableView?
    
    var viewModel : RestaurantListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.delegate = self
        table?.dataSource = self
    }
    
    func dataDidLoad() {
        table?.reloadData()
    }
}

extension RestaurantListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewmodel = viewModel, let count = viewmodel.containerCount() else {
            return 0
        }
        return count
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
            
        // Cell content
        let element = viewModel?.dataService?.containerElement(at: indexPath.row)
        cell.restaurantTitle?.text = (element?.title)!
        cell.restaurantDescription?.text = (element?.description)!
        cell.restaurantImage = UIImageView()
        
        return cell
    }
}

