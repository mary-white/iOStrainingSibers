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

class ViewController: UIViewController {
    
    @IBOutlet var table : UITableView?
    @IBOutlet var reloadtableButton : UIButton?
    
    // cell variables
    var cellNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reloadtableButton?.setTitle("Update the table context", for: .normal)
        
        // generate cell number
        cellNumber = Int.random(in: 1...maxCellNumber)
        
        table?.dataSource = self                                                                                 // who cay be?
        //table.delegate = self                                                                                 // necessary?
        table?.register(UITableViewCell.self, forCellReuseIdentifier: "standartCell")
    }
    
    @IBAction func updateTableData() {
        cellNumber = Int.random(in: 1...maxCellNumber)
        table?.reloadData()
    }

    func generateDataForTable() -> String {
        return String(Int.random(in: 0...maxNumberInCell))
    }
}

// table generation - overload function
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Ask for a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath)
            
       // Cell content
        cell.textLabel!.text = generateDataForTable()
        
       return cell
    }
}

