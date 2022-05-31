//
//  EditViewController.swift
//  FennecFox
//
//  Created by student on 20.05.2022.
//

import UIKit

class EditViewController: UIViewController {
    
    //text editor
    @IBOutlet var saveButton : UIButton?
    @IBOutlet var textFieldOfValue : UITextField?
    
    //color editor
    @IBOutlet var colorView : UIImageView?
    @IBOutlet var redColorComponent : UITextField?
    @IBOutlet var greenColorComponent : UITextField?
    @IBOutlet var blueColorComponent : UITextField?
    @IBOutlet var colorUpdateButton : UIButton?
    
    // delegate
    weak var delegate : EditViewControllerDelegate? = nil
    
    var viewModel : EditViewModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldOfValue?.text = viewModel?.dataContainerElementText()
        
        colorView?.backgroundColor = viewModel?.dataContainerElementColor()
        
        let rgbOldColor = viewModel?.dataContainerElementColorInRGBFormat()
        redColorComponent?.text = rgbOldColor?.red
        greenColorComponent?.text = rgbOldColor?.green
        blueColorComponent?.text = rgbOldColor?.blue
    }
    
    @IBAction func saveNewCellValue() {
        if !(viewModel?.saveNewMeansToDataContainer(number: textFieldOfValue?.text, red: redColorComponent?.text, green: greenColorComponent?.text, blue: blueColorComponent?.text))! {
            return
        }
        
        delegate?.didChangeData()
    
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func updateColor() {
        if !(viewModel?.setDataContainerElementColor(red: redColorComponent?.text, green: greenColorComponent?.text, blue: blueColorComponent?.text))! {
            return
        }
        colorView?.backgroundColor = viewModel?.dataContainerElementColor()
    }
}

protocol EditViewControllerDelegate : AnyObject {
    func didChangeData();
}
