//
//  StatisticViewController.swift
//  FennecFox
//
//  Created by student on 31.05.2022.
//

import UIKit

class StatisticViewController: UIViewController {
    
    @IBOutlet var minValueLabel : UILabel?
    @IBOutlet var maxValueLabel : UILabel?
    @IBOutlet var meanValueLabel : UILabel?
    
    @IBOutlet var statisticHistogram : UIImageView?
    
    var viewModel : StatisticViewModel = StatisticViewModel()
    
    let barNumber = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        updateDataLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateDataLabels()
    }
    
    func updateDataLabels() {
        let statistics = viewModel.statisticFromDataContainer()
        minValueLabel?.text = statistics.min
        maxValueLabel?.text = statistics.max
        meanValueLabel?.text = statistics.mean
        
        drawHistogram()
    }
    
    func drawHistogram() {
        guard let floatWidth = statisticHistogram?.bounds.width,
                let floatHeight = statisticHistogram?.bounds.height else {
            return
        }
        
        // contants
        let yIndent = 10
        let xIndent = 13
        
        let width = Int(floatWidth)
        let height = Int(floatHeight)
        
        let halfLineLength = 5
        
        let yStepNumber = 10
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let barWidth = width - 3*xIndent
        let barHeight = height - 3*yIndent
        
        // get data
        let dataForBar = viewModel.statisticDistribution(barNumber: barNumber)
        //print(dataForBar)

        let img = renderer.image { context in
            // x axis
            context.cgContext.addLines(between: [CGPoint(x: barWidth + 2*xIndent, y: barHeight), CGPoint(x: 2*xIndent, y: barHeight)])
            //y axis
            context.cgContext.addLines(between: [CGPoint(x: 2*xIndent, y: barHeight + yIndent), CGPoint(x: 2*xIndent, y: 0)])
            
            // steps
            let xLabelStep : Int = barWidth / barNumber
            
            guard let maxValue = dataForBar.max() else {
                return
            }
            let yStep : Double = Double(barHeight + yIndent) / (Double(maxValue) * 1.1)
            let yLabelStep : Int = (barHeight + yIndent) / yStepNumber
            
            // y label
            for i in 1...yStepNumber {
                context.cgContext.addLines(between: [CGPoint(x: 2*xIndent + halfLineLength, y: i*yLabelStep - yIndent), CGPoint(x: 2*xIndent - halfLineLength, y: i*yLabelStep - yIndent)])
                let yAxisLabel : String = String(i * Int(Double(maxValue) * 1.1) / yStepNumber)
                
                yAxisLabel.draw(at: CGPoint(x: 0, y: height - i*yLabelStep - Int(3.5*Double(yIndent))), withAttributes: [:])
            }
            let yAxisLabel : String = "0"
            yAxisLabel.draw(at: CGPoint(x: 0, y: height - Int(3.5*Double(yIndent))), withAttributes: [:])
            
            let xAxisLabel = String(Int((viewModel.dataContainer?.min())!))
            xAxisLabel.draw(at: CGPoint(x: Int(1.5*Double(xIndent)), y: height - xIndent), withAttributes: [:])
            for i in 1...barNumber {
                // x label
                context.cgContext.addLines(between: [CGPoint(x: i*xLabelStep + 2*xIndent, y: height - 3*yIndent - halfLineLength), CGPoint(x: i*xLabelStep + 2*xIndent, y: height - 3*yIndent + halfLineLength)])
                
                let xAxisLabel = String(Int((viewModel.dataContainer?.min())!) + i * Int((viewModel.dataContainer?.max())! - (viewModel.dataContainer?.min())!) / barNumber)
                xAxisLabel.draw(at: CGPoint(x: i*xLabelStep + Int(1.5*Double(xIndent)), y: height - xIndent), withAttributes: [:])
                
                // data
                let dataSize = Int(Double(dataForBar[i-1]) * yStep)
                context.cgContext.setFillColor(CGColor.init(red: 1, green: 0, blue: 0, alpha: 1))
                context.cgContext.addRect(CGRect(x: (i-1)*xLabelStep + 2*xIndent, y: barHeight - dataSize, width: xLabelStep, height: dataSize))
            }
            
            context.cgContext.drawPath(using: .fillStroke)
        }

        statisticHistogram?.image = img
    }
}
