//
//  ListController.swift
//  FennecFox
//
//  Created by student on 24.05.2022.
//

import Foundation
import UIKit

class ListController {
    // data container
    let dataContainer : ColorLabelContainer = ColorLabelContainer()
    
    // edit cell variables
    var editCellNumber : Int? = nil
    
    init() {
        let cellNumber = Int.random(in: 1...maxCellNumber)
        dataContainer.appendRandomElement(numberOfElements: cellNumber)
    }
    
    func updateTabledata() {
        let cellNumber = Int.random(in: 1...maxCellNumber)
        dataContainer.removeAll()
        dataContainer.appendRandomElement(numberOfElements: cellNumber)
    }
    
    func addNewCell() {
        dataContainer.appendRandomElement()
    }
    
    func getDataAmount() -> Int {
        return dataContainer.count
    }
    
    func getCellContent(index : Int) -> ColorLabel? {
        return dataContainer.index(at: index)
    }
    
    func getDataToChange() -> String {
        guard let cellNumberToChange = editCellNumber, let dataCell = dataContainer.index(at: cellNumberToChange) else {
            return ""
        }
        
        return dataCell.text
    }
    
    func setChangedData(newData : String?, newColor : UIColor?) {
        guard let cellNumberToChange = editCellNumber else {
            return
        }
    
        dataContainer.change(color: newColor, text: newData, at: cellNumberToChange)
        
        editCellNumber = nil
    }
    
    func getColorToChange() -> UIColor {
        guard let cellNumberToChange = editCellNumber, let dataCell = dataContainer.index(at: cellNumberToChange) else {
            return .systemRed
        }
        return dataCell.color
    }
    
}
