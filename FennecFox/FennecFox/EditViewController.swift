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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = self.navigationController?.viewControllers[0] as! DataSource
        textFieldOfValue?.text = dataSource.getDataToChange()
    }
    
    @IBAction func saveNewCellValue() {
        guard let newMean = textFieldOfValue?.text, let newCellValue = Int(newMean) else {
            return
        }
        
        let dataSource = self.navigationController?.viewControllers[0] as! DataSource
        dataSource.setChangedData(newData: newMean)
        
        self.navigationController?.popViewController(animated: true)
    }

}

protocol DataSource {
    func getDataToChange() -> String;
    func setChangedData(newData : String);
}
