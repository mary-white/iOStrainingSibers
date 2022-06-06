//
//  ViewController.swift
//  FennecFox
//
//  Created by student on 20.05.2022.
//

import UIKit

class ColorCell : UITableViewCell {
    @IBOutlet var color : UIImageView?
    @IBOutlet var colorText : UILabel?
}

class ListViewController: UIViewController {
    
    @IBOutlet var table : UITableView?
    @IBOutlet var reloadTableButton : UIButton?
    @IBOutlet var addNewCellButton : UIButton?
    
    var viewModel : ListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.dataSource = self
        table?.delegate = self
    }
    
    @IBAction func updateTableData() {
        viewModel?.updateDataInContainer()
        table?.reloadData()
    }
}

// table generation - overload function
extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewmodel = viewModel else {
            return 0
        }
        return viewmodel.dataContainerCount()
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCellType", for: indexPath) as! ColorCell
            
        // Cell content
        cell.colorText?.text = viewModel?.dataContainerElementText(at: indexPath.row)
        let color = viewModel?.dataContainerElementColor(at: indexPath.row)
        cell.colorText?.textColor = color
        cell.color?.backgroundColor = color
        
        return cell
    }
    
    // tap to a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.editingCellNumber = indexPath.row
        viewModel?.willChangeData()
    }
    
    @IBAction func addNewRandomCell() {
        viewModel?.appendRandomElementToContainer()
        table?.reloadData()
    }
    
    // protocol functions
    func didChangeData() {
        table?.reloadData()
    }
    
    /*private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }*/
}
