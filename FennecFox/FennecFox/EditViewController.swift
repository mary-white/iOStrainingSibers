//
//  EditViewController.swift
//  FennecFox
//
//  Created by student on 20.05.2022.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet var saveButton : UIButton?
    @IBOutlet var textFieldOfValue : UITextField?
    
    var selectedCellContext = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNewCellValue() {
        guard let newCellValue = Int((textFieldOfValue?.text)!) else {
            return
        }
    }

}
