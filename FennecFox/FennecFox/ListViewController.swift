//
//  ViewController.swift
//  FennecFox
//
//  Created by student on 20.05.2022.
//

import UIKit

// constants
let maxCellNumber = 10
let maxNumberInCell = 10
let defaultColor = UIColor.systemRed

class ColorCell : UITableViewCell {
    @IBOutlet var color : UIImageView?
    @IBOutlet var colorText : UILabel?
}

class ListViewController: UIViewController, EditViewControllerDelegate {
    
    @IBOutlet var table : UITableView?
    @IBOutlet var reloadTableButton : UIButton?
    @IBOutlet var addNewCellButton : UIButton?
    
    // data container
    let dataContainer : ColorLabelContainer = ColorLabelContainer()
    
    // edit cell variables
    var editingCellNumber : Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // generate cell number
        dataContainer.generateRandomNumberOfElements()
        
        table?.dataSource = self
        table?.delegate = self
    }
    
    @IBAction func updateTableData() {
        dataContainer.generateRandomNumberOfElements()
        table?.reloadData()
    }
}

// table generation - overload function
extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataContainer.count
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCellType", for: indexPath) as! ColorCell
            
        // Cell content
        let content = dataContainer.element(at: indexPath.row)
        
        cell.colorText?.text = content?.text
        cell.colorText?.textColor = content?.color
        cell.color?.backgroundColor = content?.color
        
        return cell
    }
    
    // tap to a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editingCellNumber = indexPath.row
        
        // create and configure the new view
        let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editViewController.delegate = self
        let oldData = dataContainer.element(at: editingCellNumber!)
        editViewController.textToChange = oldData?.text
        editViewController.colorToChange = oldData?.color
        
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @IBAction func addNewRandomCell() {
        dataContainer.appendRandomElement()
        table?.reloadData()
    }
    
    // protocol functions
    func getDataToChange() -> String {
        guard let cellNumberToChange = editingCellNumber, let dataCell = dataContainer.element(at: cellNumberToChange) else {
            return ""
        }
        return dataCell.text
    }
    
    func didChangeData(newData : String?, newColor : UIColor?) {
        guard let cellNumberToChange = editingCellNumber else {
            return
        }
    
        dataContainer.change(color: newColor, text: newData, at: cellNumberToChange)
        table?.reloadData()
        
        editingCellNumber = nil
    }
    
    func getColorToChange() -> UIColor {
        guard let cellNumberToChange = editingCellNumber, let dataCell = dataContainer.element(at: cellNumberToChange) else {
            return defaultColor
        }
        return dataCell.color
    }
}
