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
    
    var viewModel : StatisticViewModel?
    
    let barNumber = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        updateDataLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateDataLabels()
    }
    
    func updateDataLabels() {
        let statistics = viewModel?.statisticFromDataContainer()
        minValueLabel?.text = statistics?.min
        maxValueLabel?.text = statistics?.max
        meanValueLabel?.text = statistics?.mean
        
        drawHistogram()
    }
    
    func drawHistogram() {
        guard let floatHistWidth = statisticHistogram?.bounds.width,
                let floatHistHeight = statisticHistogram?.bounds.height else {
            return
        }
        
        // contants
        let yIndent = 10
        let xIndent = 13
        
        let histFrameWidth = Int(floatHistWidth)
        let histFrameHeight = Int(floatHistHeight)
        let xZero = 2*xIndent
        
        let halfLineLength = 5
        
        let yStepNumber = 10
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: histFrameWidth, height: histFrameHeight))
        
        let histWidth = histFrameWidth - 3*xIndent
        let histHeight = histFrameHeight - 3*yIndent
        
        // get data
        let dataForHist = viewModel?.statisticDistribution(barNumber: barNumber)
        //print(dataForBar)
        
        // steps
        let xLabelStep : Int = histWidth / barNumber
        
        guard let maxHistValue = dataForHist?.max() else {
            return
        }
        let yStep : Double = Double(histHeight + yIndent) / (Double(maxHistValue) * 1.1)
        let yLabelStep : Int = (histHeight + yIndent) / yStepNumber

        let img = renderer.image { context in
            // x axis
            context.cgContext.addLines(between: [CGPoint(x: histWidth + xZero, y: histHeight), CGPoint(x: xZero, y: histHeight)])
            //y axis
            context.cgContext.addLines(between: [CGPoint(x: xZero, y: histHeight + yIndent), CGPoint(x: xZero, y: 0)])
            
            // y label
            for i in 0...yStepNumber {
                context.cgContext.addLines(between: [CGPoint(x: xZero + halfLineLength, y: i*yLabelStep - yIndent), CGPoint(x: xZero - halfLineLength, y: i*yLabelStep - yIndent)])
                
                let yAxisLabel : String = String(i * Int(Double(maxHistValue) * 1.1) / yStepNumber)
                yAxisLabel.draw(at: CGPoint(x: 0, y: histFrameHeight - i*yLabelStep - Int(3.5*Double(yIndent))), withAttributes: [:])
            }
            
            let xAxisLabel = String(Int((viewModel?.dataContainer?.min())!))
            xAxisLabel.draw(at: CGPoint(x: Int(1.5*Double(xIndent)), y: histFrameHeight - xIndent), withAttributes: [:])
            for i in 1...barNumber {
                // x label
                context.cgContext.addLines(between: [CGPoint(x: i*xLabelStep + xZero, y: histFrameHeight - 3*yIndent - halfLineLength), CGPoint(x: i*xLabelStep + xZero, y: histFrameHeight - 3*yIndent + halfLineLength)])
                
                let xAxisLabel = String(Int((viewModel?.dataContainer?.min())!) + i * Int((viewModel?.dataContainer?.max())! - (viewModel?.dataContainer?.min())!) / barNumber)
                xAxisLabel.draw(at: CGPoint(x: i*xLabelStep + Int(1.5*Double(xIndent)), y: histFrameHeight - xIndent), withAttributes: [:])
                
                // data
                let histDataValue = Int(Double((dataForHist)![i-1]) * yStep)
                context.cgContext.setFillColor(CGColor.init(red: 1, green: 0, blue: 0, alpha: 1))
                context.cgContext.addRect(CGRect(x: (i-1)*xLabelStep + xZero, y: histHeight - histDataValue, width: xLabelStep, height: histDataValue))
            }
            
            context.cgContext.drawPath(using: .fillStroke)
        }

        statisticHistogram?.image = img
    }
}
