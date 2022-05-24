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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldOfValue?.text = selectedCellContext
    }
    
    @IBAction func saveNewCellValue() {
        guard let newMean = textFieldOfValue?.text, let newCellValue = Int(newMean) else {
            return
        }
        
        selectedCellContext = String(newCellValue)
        
        self.navigationController?.popViewController(animated: true)
    }

}

protocol DataSource {
    func getDataToChange() -> String;
    func setChangedData(newData : String);
}
