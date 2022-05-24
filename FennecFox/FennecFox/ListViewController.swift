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

class ColorCell : UITableViewCell {
    @IBOutlet var color : UIImageView?
    @IBOutlet var colorText : UILabel?
}

class ListViewController: UIViewController, DataSource {
    
    @IBOutlet var table : UITableView?
    @IBOutlet var reloadtableButton : UIButton?
    @IBOutlet var addingNewCellButton : UIButton?
    
    // data container
    let dataContainer : ColorLabelContainer = ColorLabelContainer()
    
    // edit cell variables
    var editCellNumber : Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadtableButton?.setTitle("Update the table context", for: .normal)
        addingNewCellButton?.setTitle("Add new random cell", for: .normal)
        
        // generate cell number
        let cellNumber = Int.random(in: 1...maxCellNumber)
        dataContainer.appendRandom(number: cellNumber)
        
        table?.dataSource = self
        table?.delegate = self
    }
    
    @IBAction func updateTableData() {
        let cellNumber = Int.random(in: 1...maxCellNumber)
        dataContainer.removeAll()
        dataContainer.appendRandom(number: cellNumber)
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
        let content = dataContainer.index(at: indexPath.row)
        
        cell.colorText?.text = content?.text
        cell.colorText?.textColor = content?.color
        cell.color?.backgroundColor = content?.color
        
        return cell
    }
    
    // tap to a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editCellNumber = indexPath.row
        
        // create and configure the new view
        let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @IBAction func addNewCell() {
        dataContainer.appendRandom()
        table?.reloadData()
    }
    
    // protocol functions
    func getDataToChange() -> String {
        guard let cellNumberToChange = editCellNumber, let dataCell = dataContainer.index(at: cellNumberToChange) else {
            return ""
        }
        return dataCell.text
    }
    
    func setChangedData(newData : String?, newColor : UIColor?) {
        guard let cellNumberToChange = editCellNumber else {
            return
        }
    
        dataContainer.change(color: newColor, text: newData, at: cellNumberToChange)
        table?.reloadData()
        
        editCellNumber = nil
    }
    
    func getColorToChange() -> UIColor {
        guard let cellNumberToChange = editCellNumber, let dataCell = dataContainer.index(at: cellNumberToChange) else {
            return .systemRed
        }
        return dataCell.color
    }
}
