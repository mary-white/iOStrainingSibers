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
    var dataSource : DataSource? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let oldColor = dataSource?.getColorToChange(), let textToChange = dataSource?.getDataToChange() else {
            return
        }
        
        textFieldOfValue?.text = textToChange
        
        colorView?.backgroundColor = oldColor
        
        let rgbOldColor = oldColor.rgbaComponents
        redColorComponent?.text = String(convertRGBToInt(rgbOldColor.red))
        greenColorComponent?.text = String(convertRGBToInt(rgbOldColor.green))
        blueColorComponent?.text = String(convertRGBToInt(rgbOldColor.blue))
    }
    
    @IBAction func saveNewCellValue() {
        guard let newNumberMean = textFieldContentToInt(textFieldOfValue) else {
            return
        }
        
        guard let newRedComponentMean = textFieldContentToInt(redColorComponent) else {
            return
        }
        
        guard let newGreenComponentMean = textFieldContentToInt(greenColorComponent) else {
            return
        }
        
        guard let newBlueComponentMean = textFieldContentToInt(blueColorComponent) else {
            return
        }
        
        dataSource?.setChangedData(newData: String(newNumberMean), newColor: UIColor(red: convertIntToRGB(newRedComponentMean), green: convertIntToRGB(newGreenComponentMean), blue: convertIntToRGB(newBlueComponentMean), alpha: 1))
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func updateColor() {
        guard let newRedComponentMean = textFieldContentToInt(redColorComponent) else {
            return
        }
        
        guard let newGreenComponentMean = textFieldContentToInt(greenColorComponent) else {
            return
        }
        
        guard let newBlueComponentMean = textFieldContentToInt(blueColorComponent) else {
            return
        }
        
        colorView?.backgroundColor = UIColor(red: convertIntToRGB(newRedComponentMean), green: convertIntToRGB(newGreenComponentMean), blue: convertIntToRGB(newBlueComponentMean), alpha: 1)
    }
}

extension UIColor {
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red: red, green: green, blue: blue, alpha: alpha)
    }
}

protocol DataSource {
    // getter
    func getDataToChange() -> String;
    func getColorToChange() -> UIColor;
    
    //setter
    func setChangedData(newData : String?, newColor : UIColor?);
}

func convertRGBToInt(_ mean : CGFloat) -> Int {
    return Int(floor(mean * 255))
}

func convertIntToRGB(_ mean : Int) -> CGFloat {
    let newMean = CGFloat(mean) / 255
    return newMean < 1 ? newMean : 1
}

func textFieldContentToInt(_ field : UITextField?) -> Int? {
    guard let stringValue = field?.text else {
        return nil
    }
    return Int(stringValue)
}
