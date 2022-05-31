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

class ListViewModel {
    // data container
    let dataContainer : ColorLabelContainer = ColorLabelContainer()
    
    // edit cell variables
    var editingCellNumber : Int? = nil
    
    var editViewModel : EditViewModel? = nil
    
    init() {
        dataContainer.generateRandomNumberOfElements()
    }
    
    func updateDataInContainer() {
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

        let newNumber = Double(newData ?? "")
        dataContainer.change(color: newColor, number: newNumber, at: cellNumberToChange)
        editingCellNumber = nil
    }
    
    func createEditViewModel() {
        guard let _ = editingCellNumber else {
            return
        }
        editViewModel = EditViewModel(self)
    }
}

func stringViewOfNumber(number : Double) -> String {
    // divide into categories
    let numberMod = abs(number)
    let dozens : Int = Int(floor(numberMod / 10))
    let units : Int = Int(floor(numberMod)) % 10
    let tenths : Int = Int(numberMod * 10) % 10
    let hundredths = Int(round(numberMod * 100)) % 10
    
    var finalNumberView : String = ""
    if number < 0 {
        finalNumberView = "минус "
    }
    
    // whole part
    finalNumberView += convertTwoDigitNumber(dozens: dozens, units: units)
    
    if tenths == 0 && hundredths == 0 {
        return finalNumberView
    }
    
    // if the number has fraction part
    if units == 1 && dozens != 1 {
        let range = finalNumberView.index(finalNumberView.endIndex, offsetBy: -2)..<finalNumberView.endIndex
        finalNumberView.removeSubrange(range)
        finalNumberView += "на целая"
    }
    else if units == 2 && dozens != 1 {
        finalNumberView.remove(at: finalNumberView.index(before: finalNumberView.endIndex))
        finalNumberView += "е целых"
    }
    else {
        finalNumberView += " целых"
    }
    
    // add fraction part
    finalNumberView += " " + convertTwoDigitNumber(dozens: tenths, units: hundredths)
    if hundredths == 1 && tenths != 1 {
        let range = finalNumberView.index(finalNumberView.endIndex, offsetBy: -2)..<finalNumberView.endIndex
        finalNumberView.removeSubrange(range)
        finalNumberView += "на сотая"
    }
    else if hundredths == 2 && tenths != 1 {
        finalNumberView.remove(at: finalNumberView.index(before: finalNumberView.endIndex))
        finalNumberView += "е сотых"
    }
    else {
        finalNumberView += " сотых"
    }
    
    return finalNumberView
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
        switch d {
        case 2, 3:
            point += intToStringFrom0To9[d]! + "дцать"
        case 4:
            point += "сорок"
        case 9:
            point += "девяносто"
        default:
            point += intToStringFrom0To9[d]! + "десят"
        }
        
        if u == 0 {
            break
        }
        
        point += " " + intToStringFrom0To9[u]!
    }
    return point
}

