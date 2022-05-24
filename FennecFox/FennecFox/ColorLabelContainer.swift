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
    var colorLabelArray : Array<ColorLabel> = []
    
    var count : Int {
        get {
            return colorLabelArray.count
        }
    }
    
    // insert
    func append(color : UIColor, text : String) {
        let newColorLabel = ColorLabel(color: color, text: text)
        colorLabelArray.append(newColorLabel)
    }
    
    func generateRandomNumberOfElements() {
        removeAll()
        let randomNumberOfElements = Int.random(in: 1...maxCellNumber)
        appendRandomElement(numberOfElements: randomNumberOfElements)
    }
    
    func appendRandomElement(numberOfElements : Int = 1) {
        for _ in 0..<numberOfElements {
            let randomRedColorComponent = CGFloat.random(in: 0...1)
            let randomGreenColorComponent = CGFloat.random(in: 0...1)
            let randomBlueColorComponent = CGFloat.random(in: 0...1)
            let randomColor = UIColor(red: randomRedColorComponent, green: randomGreenColorComponent, blue: randomBlueColorComponent, alpha: 1)
            
            let randomNumber = Int.random(in: 0...maxCellNumber)
            append(color: randomColor, text: String(randomNumber))
        }
    }
    
    func insert(color : UIColor, text : String, at index : Int) {
        let newColorlable = ColorLabel(color: color, text: text)
        colorLabelArray.insert(newColorlable, at: index)
    }
    
    func change(color : UIColor?, text : String?, at index : Int) {
        if index >= colorLabelArray.count || index < 0 {
            return
        }
        
        colorLabelArray[index].color = color ?? colorLabelArray[index].color
        colorLabelArray[index].text = text ?? colorLabelArray[index].text
    }
    
    //remove
    func remove(at index : Int) {
        colorLabelArray.remove(at: index)
    }
    
    func removeAll() {
        colorLabelArray.removeAll()
    }
    
    // getter
    func index(at index : Int) -> ColorLabel? {
        return index >= colorLabelArray.count || index < 0 ? nil : colorLabelArray[index]
    }
}
