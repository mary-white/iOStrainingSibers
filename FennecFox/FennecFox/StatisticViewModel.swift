//
//  StatisticViewModel.swift
//  FennecFox
//
//  Created by student on 31.05.2022.
//

import Foundation

class StatisticViewModel {
    var dataContainer : ColorLabelContainer? = nil
    
    func statisticFromDataContainer() -> (min : String, max : String, mean : String) {
        guard let data = dataContainer else {
            return (min : "", max : "", mean : "")
        }
        guard let resultMin = data.min(), let resultMax = data.max(), let resultMean = data.mean() else {
            return (min : "", max : "", mean : "")
        }
        
        let roundResultMean = round(resultMean * 1000) / 1000
        
        return (min : String(resultMin), max : String(resultMax), mean : String(roundResultMean))
    }
    
    func statisticDistribution(barNumber : Int) -> [Int] {
        guard let dataContainerCount = dataContainer?.count, let minValue = dataContainer?.min() else {
            return []
        }
        
        var result : [Int] = Array(repeating: 0, count:  barNumber)
        
        for index in 0..<dataContainerCount {
            guard let value = dataContainer?.element(at: index)?.number else {
                return []
            }
            result[Int(round(value) - minValue) % barNumber] += 1
        }
        return result
    }
}
