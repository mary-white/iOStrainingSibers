//
//  ColorCellContainer.swift
//  FennecFox
//
//  Created by student on 24.05.2022.
//

import Foundation
import UIKit

struct ColorLabel {
    var color : UIColor = .systemRed
    var text : String = ""
}

class ColorLabelContainer {
    var cellArray : Array<ColorLabel> = []
    
    // insert
    func append(color : UIColor, text : String) {
        let newColorLabel = ColorLabel(color: color, text: text)
        cellArray.append(newColorLabel)
    }
    
    func appendRandom() {
        let randomRedColorComponent = CGFloat.random(in: 0..<255)
        let randomGreenColorComponent = CGFloat.random(in: 0..<255)
        let randomBlueColorComponent = CGFloat.random(in: 0..<255)
        let randomAlphaColorComponent = CGFloat.random(in: 0..<1)
        let randomColor = UIColor(red: randomRedColorComponent, green: randomGreenColorComponent, blue: randomBlueColorComponent, alpha: randomAlphaColorComponent)
        
        let randomNumber = Int.random(in: 0...maxCellNumber)
        append(color: randomColor, text: String(randomNumber))
    }
    
    func insert(color : UIColor, text : String, at index: Int) {
        let newColorlable = ColorLabel(color: color, text: text)
        cellArray.insert(newColorlable, at: index)
    }
    
    //remove
    func remove(at index : Int) {
        cellArray.remove(at: index)
    }
    
    func removeAll() {
        cellArray.removeAll()
    }
    
    // getter
    func index(at index : Int) -> ColorLabel? {
        if index >= cellArray.count || index < 0 {
            return nil
        }
        
        return cellArray[index]
    }
}
