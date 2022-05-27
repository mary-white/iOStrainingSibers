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
    var number : Double = 0
}

class ColorLabelContainer {
    var colorLabelArray : Array<ColorLabel> = []
    
    var count : Int {
        get {
            return colorLabelArray.count
        }
    }
    
    // insert
    func append(color : UIColor, number : Double) {
        let newColorLabel = ColorLabel(color: color, number: number)
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
            
            let randomNumber = round(Double.random(in: -99.99...99.99) * 100) / 100
            
            append(color: randomColor, number: randomNumber)
        }
    }
    
    func insert(color : UIColor, number : Double, at index : Int) {
        let newColorlable = ColorLabel(color: color, number: number)
        colorLabelArray.insert(newColorlable, at: index)
    }
    
    func change(color : UIColor?, number : Double?, at index : Int) {
        if index >= colorLabelArray.count || index < 0 {
            return
        }
        
        colorLabelArray[index].color = color ?? colorLabelArray[index].color
        colorLabelArray[index].number = number ?? colorLabelArray[index].number
    }
    
    //remove
    func remove(at index : Int) {
        colorLabelArray.remove(at: index)
    }
    
    func removeAll() {
        colorLabelArray.removeAll()
    }
    
    // getter
    func element(at index : Int) -> ColorLabel? {
        return index >= colorLabelArray.count || index < 0 ? nil : colorLabelArray[index]
    }
}
