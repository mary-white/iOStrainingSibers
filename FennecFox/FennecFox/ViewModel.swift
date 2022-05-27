//
//  ViewModel.swift
//  FennecFox
//
//  Created by student on 27.05.2022.
//

import Foundation
import UIKit

// constants
let maxCellNumber = 10
let defaultColor = UIColor.systemRed

class ViewModel {
    // data container
    let dataContainer : ColorLabelContainer = ColorLabelContainer()
    
    // edit cell variables
    var editingCellNumber : Int? = nil
    
    init() {
        dataContainer.generateRandomNumberOfElements()
        for number in stride(from: -99.99, to: 99.99, by: 0.01) {
            print(number, terminator: " ")
            print(stringViewOfNumber(number: number))
        }
        
    }
    
    func updateContainerData() {
        dataContainer.generateRandomNumberOfElements()
    }
    
    func dataContainerCount() -> Int {
        return dataContainer.count
    }
    
    func dataContainerElementColor(at index: Int) -> UIColor {
        return dataContainer.element(at: index)?.color ?? defaultColor
    }
    
    func dataContainerElementText(at index: Int) -> String {
        guard let newNumber = dataContainer.element(at: index)?.number else {
            return ""
        }
        return stringViewOfNumber(number: newNumber)
    }
    
    func appendRandomElementToContainer() {
        dataContainer.appendRandomElement()
    }
    
    func dataContainerElementTextToChange() -> String {
        guard let cellIndex = editingCellNumber, let newNumber = dataContainer.element(at: cellIndex)?.number else {
            return ""
        }
        return String(newNumber)
    }
    
    func dataContainerElementColorToChange() -> UIColor {
        guard let cellIndex = editingCellNumber else {
            return defaultColor
        }
        return dataContainerElementColor(at: cellIndex)
    }
    
    func changeData(newData: String?, newColor: UIColor?) {
        guard let cellNumberToChange = editingCellNumber else {
            return
        }

        let newNumber = newData == nil ? nil : Double(newData!)
        dataContainer.change(color: newColor, number: newNumber, at: cellNumberToChange)
        editingCellNumber = nil
    }
}

func stringViewOfNumber(number : Double) -> String {
    // divide into categories
    let numberMod = abs(number)
    let dozens : Int = Int(floor(numberMod / 10))
    let units : Int = Int(floor(numberMod)) % 10
    let tenths : Int = Int(numberMod * 10) % 10
    let hundredths = Int(numberMod * 100) % 10
    
    var point : String = ""
    if number < 0 {
        point = "минус "
    }
    
    // whole part
    point += convertTwoDigitNumber(dozens: dozens, units: units)
    
    if tenths == 0 && hundredths == 0 {
        return point
    }
    
    // if the number has fraction part
    if units == 1 && dozens != 1 {
        let range = point.index(point.endIndex, offsetBy: -2)..<point.endIndex
        point.removeSubrange(range)
        point += "на целая"
    }
    else if units == 2 && dozens != 1 {
        point.remove(at: point.index(before: point.endIndex))
        point += "е целых"
    }
    else {
        point += " целых"
    }
    
    // add fraction part
    point += " " + convertTwoDigitNumber(dozens: tenths, units: hundredths)
    if hundredths == 1 && tenths != 1 {
        let range = point.index(point.endIndex, offsetBy: -2)..<point.endIndex
        point.removeSubrange(range)
        point += "на сотая"
    }
    else if hundredths == 2 && tenths != 1 {
        point.remove(at: point.index(before: point.endIndex))
        point += "е сотых"
    }
    else {
        point += " сотых"
    }
    
    return point
}

func convertTwoDigitNumber(dozens : Int, units : Int) -> String {
    let intToStringFrom0To9 : [Int: String] = [0: "ноль", 1: "один", 2: "два", 3: "три", 4: "четыре", 5: "пять", 6: "шесть", 7: "семь", 8: "восемь", 9: "девять"]
    
    var point : String = ""
    
    switch (dozens, units) {
    case (1, let u) : //  десять - девятнадцать
        if u == 0 {
            point += "десять"
            break
        }
        point += intToStringFrom0To9[u]!
        if [2, 4, 5, 6, 7, 8, 9].contains(u) {
            //point.dropLast()
            point.remove(at: point.index(before: point.endIndex))
            if u == 2 {
                point += "e"
            }
        }
        point += "надцать"
        
    case (0, let u) : // ноль - девять
        point += intToStringFrom0To9[u]!
        
    case (let d, let u) :
        if [2, 3].contains(d) {
            point += intToStringFrom0To9[d]! + "дцать"
        }
        else if d == 4 {
            point += "сорок"
        }
        else if d == 9 {
            point += "девяносто"
        }
        else {
            point += intToStringFrom0To9[d]! + "десят"
        }
        
        if u == 0 {
            break
        }
        
        point += " " + intToStringFrom0To9[u]!
    }
    return point
}

