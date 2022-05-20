//
//  ViewController.swift
//  FennecFox
//
//  Created by student on 20.05.2022.
//

import UIKit

// constants
let maxCellNumber = 30
let maxNumberInCell = 10

class ListViewController: UIViewController {
    
    @IBOutlet var table : UITableView?
    @IBOutlet var reloadtableButton : UIButton?
    
    // cell variables
    var cellNumber = 0
    var tableContext : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        reloadtableButton?.setTitle("Update the table context", for: .normal)
        
        // generate cell number
        cellNumber = Int.random(in: 1...maxCellNumber)
        generateDataForTable()
        
        table?.dataSource = self
        table?.delegate = self
        table?.register(UITableViewCell.self, forCellReuseIdentifier: "standartCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "standartCell", for: indexPath)
            
        // Cell content
        cell.textLabel!.text = String(tableContext[indexPath.row])
        return cell
    }
    
    @objc func actionToCellTap() {
        reloadtableButton?.setTitle("adsffss", for: .normal)
    }
}
