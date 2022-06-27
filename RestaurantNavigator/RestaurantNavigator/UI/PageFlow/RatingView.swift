//
//  RatingView.swift
//  RestaurantNavigator
//
//  Created by student on 24.06.2022.
//

import Foundation
import UIKit

let ratingStarCount = 10
let maxRatingValue = 10.0

let starColor = UIColor.systemYellow.cgColor
let defaultStarColor = UIColor.systemGray5.cgColor

class RatingView {
    var maxValue : Double
    var starCount : Int
    var rating : Double
    
    init(rating : Double, starCount : Int = ratingStarCount, maxValue : Double = maxRatingValue) {
        self.rating = rating
        self.maxValue = maxValue
        self.starCount = starCount
        
        if rating > maxValue {
            self.rating = maxValue
        }
    }
    
    func draw(areaSize : CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: areaSize.width, height: areaSize.height))
        
        let img = renderer.image { context in
            let halfStarHeight = areaSize.height / 2
            let halfStarWeight = CGFloat(Float(areaSize.width) / Float(starCount)) / 2
            let outerStarRadius = min(halfStarHeight, halfStarWeight)
            let innerStarRadius = outerStarRadius / 2
            
            let verticleAngles : [CGFloat] = Array(stride(from: 0, to: 2 * CGFloat.pi, by: 36 / 180 * CGFloat.pi))
            
            // draw zero star area
            context.cgContext.setFillColor(defaultStarColor)
            context.cgContext.addRect(CGRect(x: 0, y: 0, width: areaSize.width, height: areaSize.height))
            context.cgContext.drawPath(using: .fill)
            
            // draw full star area
            let ratingAreaWidth = self.rating * (areaSize.width / maxRatingValue)
            context.cgContext.setFillColor(starColor)
            context.cgContext.addRect(CGRect(x: 0, y: 0, width: ratingAreaWidth, height: areaSize.height))
            context.cgContext.drawPath(using: .fill)
            
            // draw star
            context.cgContext.setFillColor(UIColor.white.cgColor)
            context.cgContext.addRect(CGRect(x: 0, y: 0, width: areaSize.width, height: areaSize.height))
            
            var starPaths : [CGPath] = []
            for starNumber in 0..<starCount {
                let step = CGFloat(starNumber) * halfStarWeight * 2 + halfStarWeight
                let starPath = CGMutablePath()
                
                for i in 0..<verticleAngles.count {
                    let angle = verticleAngles[i]
                    let radius = i % 2 == 0 ? innerStarRadius : outerStarRadius
                    
                    let point = CGPoint(x: step + radius * cos(angle), y: halfStarHeight + radius * sin(angle))
                    // first point
                    if i == 0 {
                        starPath.move(to: point)
                        continue
                    }
                    
                    starPath.addLine(to: point)
                    
                    // end point
                    if i == verticleAngles.count - 1 {
                        starPath.closeSubpath()
                    }
                }

                context.cgContext.addPath(starPath)
                starPaths.append(starPath)
            }
            
            context.cgContext.drawPath(using: .eoFill)
            
            // draw lines for star
            /*context.cgContext.setLineWidth(2)
            for star in starPaths {
                context.cgContext.addPath(star)
            }
            context.cgContext.strokePath()*/
        }
        
        return img
    }
}
