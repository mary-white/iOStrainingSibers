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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = self.navigationController?.viewControllers[0] as! DataSource
        textFieldOfValue?.text = dataSource.getDataToChange()
        
        let oldColor = dataSource.getColorToChange()
        colorView?.backgroundColor = oldColor
        let rgb = oldColor.rgbaComponents
        
        
        redColorComponent?.text = String(convertRGBToInt(rgb.red))
        greenColorComponent?.text = String(convertRGBToInt(rgb.green))
        blueColorComponent?.text = String(convertRGBToInt(rgb.blue))
    }
    
    @IBAction func saveNewCellValue() {
        guard let newMean = textFieldOfValue?.text, let _ = Int(newMean) else {
            return
        }
        
        guard let newRedComponentMean = redColorComponent?.text, let rComponent = Int(newRedComponentMean) else {
            return
        }
        
        guard let newGreenComponentMean = greenColorComponent?.text, let gComponent = Int(newGreenComponentMean) else {
            return
        }
        
        guard let newBlueComponentMean = blueColorComponent?.text, let bComponent = Int(newBlueComponentMean) else {
            return
        }
        
        let dataSource = self.navigationController?.viewControllers[0] as! DataSource
        dataSource.setChangedData(newData: newMean, newColor: UIColor(red: convertIntToRGB(rComponent), green: convertIntToRGB(gComponent), blue: convertIntToRGB(bComponent), alpha: 1))
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func updateColor() {
        guard let newRedComponentMean = textFielContentToInt(redColorComponent) else {
            return
        }
        
        guard let newGreenComponentMean = textFielContentToInt(greenColorComponent) else {
            return
        }
        
        guard let newBlueComponentMean = textFielContentToInt(blueColorComponent) else {
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
    return CGFloat(mean) / 255
}

func textFielContentToInt(_ field : UITextField?) -> Int? {
    guard let stringValue = field?.text else {
        return nil
    }
    return Int(stringValue)
}
