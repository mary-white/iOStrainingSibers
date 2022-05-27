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
let maxNumberInCell = 10
let defaultColor = UIColor.systemRed

class ViewModel {
    // data container
    let dataContainer : ColorLabelContainer = ColorLabelContainer()
    
    // edit cell variables
    var editingCellNumber : Int? = nil
    
    init() {
        dataContainer.generateRandomNumberOfElements()
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
        return dataContainer.element(at: index)?.text ?? ""
    }
    
    func appendRandomElementToContainer() {
        dataContainer.appendRandomElement()
    }
    
    func dataContainerElementTextToChange() -> String {
        guard let cellIndex = editingCellNumber else {
            return ""
        }
        return dataContainerElementText(at: cellIndex)
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
        dataContainer.change(color: newColor, text: newData, at: cellNumberToChange)
        editingCellNumber = nil
    }
}
