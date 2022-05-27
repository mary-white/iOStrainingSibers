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

class ListViewController: UIViewController, EditViewControllerDelegate {
    
    @IBOutlet var table : UITableView?
    @IBOutlet var reloadTableButton : UIButton?
    @IBOutlet var addNewCellButton : UIButton?
    
    var viewModel : ListViewModel = ListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table?.dataSource = self
        table?.delegate = self
    }
    
    @IBAction func updateTableData() {
        viewModel.updateDataInContainer()
        table?.reloadData()
    }
}

// table generation - overload function
extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataContainerCount()
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCellType", for: indexPath) as! ColorCell
            
        // Cell content
        cell.colorText?.text = viewModel.dataContainerElementText(at: indexPath.row)
        let color = viewModel.dataContainerElementColor(at: indexPath.row)
        cell.colorText?.textColor = color
        cell.color?.backgroundColor = color
        
        return cell
    }
    
    // tap to a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {  // !!!!!!!!!!!!!
        viewModel.editingCellNumber = indexPath.row
        
        // create and configure the new view
        let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editViewController.delegate = self
        editViewController.textToChange = viewModel.dataContainerElementTextToChange()
        editViewController.colorToChange = viewModel.dataContainerElementColorToChange()
        
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @IBAction func addNewRandomCell() {
        viewModel.appendRandomElementToContainer()
        table?.reloadData()
    }
    
    // protocol functions
    func didChangeData(newData : String?, newColor : UIColor?) { // !!!!!!!!!!!!!
        viewModel.changeData(newData: newData, newColor: newColor)
        table?.reloadData()
    }
    
    /*private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }*/
}
