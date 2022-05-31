//
//  EditViewModel.swift
//  FennecFox
//
//  Created by student on 27.05.2022.
//

import Foundation
import UIKit

class EditViewModel {
    weak var delegate : EditViewModelDelegate? = nil
    var editingCell : ColorLabel? = nil
    
    // getters
    func textToChange() -> String {
        return String((editingCell?.number)!)
    }
    
    func colorToChange() -> UIColor {
        return (editingCell?.color)!
    }
    
    func colorToChangeInRGBFormat() -> (red: String, green: String, blue: String) {
        let oldColor = colorToChange()
        let rgbOldColor = oldColor.rgbaComponents
        let red = convertRGBToInt(rgbOldColor.red)
        let green = convertRGBToInt(rgbOldColor.green)
        let blue = convertRGBToInt(rgbOldColor.blue)
        return (red: String(red), green: String(green), blue: String(blue))
    }
    
    //setters
    func setElementColor(red : String?, green : String?, blue : String?) -> Bool {
        guard let r = Int(red ?? ""), let g = Int(green ?? ""), let b = Int(blue ?? "") else {
            return false
        }
        editingCell?.color = UIColor(red: convertIntToRGB(r), green: convertIntToRGB(g), blue: convertIntToRGB(b), alpha: 1)
        return true
    }
    
    func saveNewMeansToDataContainer(number: String?, red:String?, green: String?, blue: String?) -> Bool {
        guard let newNumber = Double(number ?? "") else {
            return false
        }
        if !setElementColor(red: red, green: green, blue: blue) {
            return false
        }
        editingCell?.number = newNumber
        delegate?.didChangeData(newData: editingCell!)
        return true
    }
    
    // converters
    func convertRGBToInt(_ mean : CGFloat) -> Int {
        return Int(floor(mean * 255))
    }
    
    func convertIntToRGB(_ mean : Int) -> CGFloat {
        let newMean = CGFloat(mean) / 255
        return newMean < 1 ? newMean : 1
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

protocol EditViewModelDelegate : AnyObject {
    func didChangeData(newData : ColorLabel);
}
