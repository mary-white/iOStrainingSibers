//
//  ViewController.swift
//  OnboardingApp
//
//  Created by student on 13.05.2022.
//

import UIKit

// flying img
struct FlyingImg {
    var image : UIView? = UIView()
    var flyightDirection : CGPoint = .zero
}

// constant
let error = 0.5

class ViewController: UIViewController {
    
    // Views
    @IBOutlet var flyightStartButton : UIButton?
    @IBOutlet var catImg : UIView?
    @IBOutlet var flyingFishNumber : UITextField?
    
    @IBOutlet var textLabel : UILabel?
    @IBOutlet var switchButton : UISwitch?
    
    // Variables - fly image
    var isFlightState : Bool = false
    var flightTimerInterval = 0.01
    var flyightTimer : Timer?
    
    // fly image chaos
    var flyightSpeed : CGFloat = 1
    
    // fly image circle
    var circleRadius : CGFloat = 100
    var angle : CGFloat = 0
    
    // flying fish
    var flyingFish : Array<FlyingImg> = Array()
    let fishImgHeight : CGFloat = 30
    let fishImgWidth : CGFloat = 30
    let fishImgName = "fish.jpeg"
    
    // flying cat
    var flyingCat : FlyingImg = FlyingImg(image: nil, flyightDirection: .zero)
    
    enum FlyightButtonText : Int {
        case flyightStart, flyightStop, otherState
        
        func simpleDescription() -> String {
            switch self {
            case .flyightStart:
                return "start fly"
            case .flyightStop:
                return "stop fly"
            default:
                return "Wow"
            }
        }
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        flyightStartButton?.setTitle(FlyightButtonText.flyightStart.simpleDescription(), for: .normal)
        textLabel?.text = "Flying cat"
        flyingCat.image = catImg
    }

    @IBAction func didTapStart() {
        var buttonTitle : FlyightButtonText
        if !isFlightState {
            // button work
            buttonTitle = FlyightButtonText.flyightStop
            
            // fly direction init
            let randomXDirection : CGFloat = CGFloat.random(in: -1...1) * flyightSpeed
            let randomYDirection : CGFloat = CGFloat.random(in: -1...1) * flyightSpeed
            flyingCat.flyightDirection = CGPoint(x: randomXDirection, y: randomYDirection)
            
            //timer turn on
            if (switchButton?.isOn)! {
                // chaos
                flyightTimer = Timer.scheduledTimer(timeInterval: flightTimerInterval, target: self, selector: #selector(moveAllImgChaotically), userInfo: nil, repeats: true)
            } else {
                // circle
                flyingCat.image?.center = CGPoint(x: (flyingCat.image?.superview?.bounds.width)! / 2 + circleRadius - 1, y: (flyingCat.image?.superview?.bounds.height)! / 2)
                flyightTimer = Timer.scheduledTimer(timeInterval: flightTimerInterval, target: self, selector: #selector(moveImgInACircle), userInfo: nil, repeats: true)
            }
        } else {
            // button work
            buttonTitle = FlyightButtonText.flyightStart
            
            //timer turn off
            flyightTimer?.invalidate()
            flyightTimer = nil
            
            // delete fish
            clearFishArray()
        }
        
        // change button state
        flyightStartButton?.setTitle(buttonTitle.simpleDescription(), for: .normal)
        isFlightState = !isFlightState
    }
    
    func clearFishArray() {
        for fish in flyingFish {
            fish.image?.removeFromSuperview()
        }
        flyingFish.removeAll()
    }
    
    // image fly
    @objc func moveAllImgChaotically() {
        // fly cat
        moveImgChaotically(flyingImg: &flyingCat)
        
        //fly fish
        var deletedFish : [Int] = []
        for i in 0..<flyingFish.count {
            moveImgChaotically(flyingImg: &flyingFish[i])
            // fix collision between cat end fish
            if isImgCollision(firstImg: flyingCat.image!, secondImg: flyingFish[i].image!) {
                // change cat direction
                let differenceXImgCenter = (flyingCat.image?.center.x)! - (flyingFish[i].image?.center.x)!
                let differenceYImgCenter = (flyingCat.image?.center.y)! - (flyingFish[i].image?.center.y)!
                
                if abs(differenceYImgCenter) < ((flyingCat.image?.bounds.height)! / 2 + (flyingFish[i].image?.bounds.height)! / 2) {
                    flyingCat.flyightDirection.x = (differenceXImgCenter > 0 ? 1 : -1) * abs(flyingCat.flyightDirection.x)
                }
                
                if abs(differenceXImgCenter) < ((flyingCat.image?.bounds.width)! / 2 + (flyingFish[i].image?.bounds.width)! / 2) {
                    flyingCat.flyightDirection.y = (differenceYImgCenter > 0 ? 1 : -1) * abs(flyingCat.flyightDirection.y)
                }
                
                // delete fish from screen
                flyingFish[i].image?.removeFromSuperview()
                deletedFish.append(i)
            }
        }
        // delete fish from array
        for i in 0..<deletedFish.count {
            flyingFish.remove(at: deletedFish[i] - i)
        }
    }
    
    func moveImgChaotically(flyingImg: inout FlyingImg) {
        flyingImg.image?.center = CGPoint(x: (flyingImg.image?.center.x)! + flyingImg.flyightDirection.x, y: (flyingImg.image?.center.y)! + flyingImg.flyightDirection.y)
        pushImgAwayFromScreenBounds(flyingImg: &flyingImg)
    }
    
    @objc func moveImgInACircle() {
        let imgXCoordinate = (flyingCat.image?.superview?.bounds.width)! / 2 + circleRadius * cos(angle)
        let imgYCoordinate = (flyingCat.image?.superview?.bounds.height)! / 2 + circleRadius * sin(angle)
        flyingCat.image?.center = CGPoint(x: imgXCoordinate, y: imgYCoordinate)
        
        angle += 0.01
        if angle >= 2 * CGFloat.pi {
            angle = 0
        }
    }
    
    // fix image boards collisions
    func pushImgAwayFromScreenBounds(flyingImg: inout FlyingImg) { // rename
        // x bound
        if (flyingImg.image?.frame.minX)! <= error  || (flyingImg.image?.superview?.bounds.width)! - (flyingImg.image?.frame.maxX)! <= error {
            flyingImg.flyightDirection.x = -1 * flyingImg.flyightDirection.x
        }
        
        //y bound
        if (flyingImg.image?.frame.minY)! <= error  || (flyingImg.image?.superview?.bounds.height)! - (flyingImg.image?.frame.maxY)! <= error {
            flyingImg.flyightDirection.y = -1 * flyingImg.flyightDirection.y
        }
    }
    
    // fix images collision
    func isImgCollision(firstImg: UIView, secondImg: UIView) -> Bool {
        return abs(secondImg.center.x - firstImg.center.x) < (firstImg.bounds.width + secondImg.bounds.width) / 2 &&
            abs(secondImg.center.y - firstImg.center.y) < (firstImg.bounds.height + secondImg.bounds.height) / 2
    }
    
    // create fish
    @IBAction func createFish() {
        if isFlightState || !(switchButton?.isOn)!{
            return
        }

        // fill using fish
        let fishNumber : Int = Int((flyingFishNumber?.text)!) ?? 0
        
        let screenBounds = flyingCat.image?.superview?.bounds
        
        for _ in 0..<fishNumber {
            var currentFish : FlyingImg = FlyingImg()
            
            // create image
            let fishImg = UIImage(named: fishImgName)
            let fishImgView = UIImageView(image: fishImg!)
                
            //create frame
            let randomInitXFish : CGFloat = CGFloat.random(in: (fishImgWidth / 2)...((screenBounds?.width)! - fishImgWidth / 2))
            let randomInitYFish : CGFloat = CGFloat.random(in: (fishImgHeight / 2)...((screenBounds?.height)! - fishImgHeight / 2))
            fishImgView.frame = CGRect(x: randomInitXFish, y: randomInitYFish, width: fishImgWidth, height: fishImgHeight)
            currentFish.image? = fishImgView
            
            // generate direction
            let randomXDirection : CGFloat = CGFloat.random(in: -1...1)
            let randomYDirection : CGFloat = CGFloat.random(in: -1...1)
            currentFish.flyightDirection = CGPoint(x: randomXDirection, y: randomYDirection)
            
            // add picture
            flyingCat.image?.superview?.addSubview(currentFish.image!) // add into the frame with cat
            flyingFish.append(currentFish)
        }
    }
}

