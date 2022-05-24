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
    
    // cell variables
    var cellNumber = 0
    var tableContext : [String] = []
    
    // edit cell variables
    var editCellNumber : Int? = nil
    var editViewController : EditViewController = EditViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadtableButton?.setTitle("Update the table context", for: .normal)
        addingNewCellButton?.setTitle("Add new random cell", for: .normal)
        
        // generate cell number
        cellNumber = Int.random(in: 1...maxCellNumber)
        generateDataForTable()
        
        table?.dataSource = self
        table?.delegate = self
        //table?.register(ColorCell.self, forCellReuseIdentifier: "colorCellType")
    }
    
    @IBAction func updateTableData() {
        cellNumber = Int.random(in: 1...maxCellNumber)
        generateDataForTable()
        table?.reloadData()
    }

    func generateDataForTable() {
        tableContext.removeAll()
        for _ in 0..<cellNumber {
            tableContext.append(String(Int.random(in: 0...maxNumberInCell)))
        }
    }
    
}

// table generation - overload function
extension ListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNumber
    }
    
    // fill the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCellType", for: indexPath) as! ColorCell
            
        // Cell content
        cell.colorText?.text = String(tableContext[indexPath.row])
        cell.color?.backgroundColor = .systemRed
        
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
        cellNumber += 1
        tableContext.append(String(Int.random(in: 0...maxNumberInCell)))
        table?.reloadData()
    }
    
    // protocol functions
    func getDataToChange() -> String {
        guard let cellNumberToChange = editCellNumber else {
            return ""
        }
        return tableContext[cellNumberToChange]
    }
    
    func setChangedData(newData : String) {
        guard let cellNumberToChange = editCellNumber else {
            return
        }
        
        tableContext[cellNumberToChange] = newData
        table?.reloadData()
        
        editCellNumber = nil
    }
}
