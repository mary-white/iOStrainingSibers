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
    var direction : CGPoint = .zero
}

// constant
let error = 0.5

class ViewController: UIViewController {
    
    // Views
    @IBOutlet var startButton : UIButton?
    @IBOutlet var catImg : UIView?
    @IBOutlet var flyingFishNumber : UITextField?
    
    @IBOutlet var textLabel : UILabel?
    @IBOutlet var switchButton : UISwitch?
    
    // Variables - fly image
    var isFlyState : Bool = false
    var timerInterval = 0.01
    var timerFly : Timer?
    
    // fly image chaos
    var flySpeed : CGFloat = 1
    
    // fly image circle
    var radius : CGFloat = 100
    var angle : CGFloat = 0
    
    // flying fish
    var flyingFish : Array<FlyingImg> = Array()
    let fishHeight : CGFloat = 30
    let fishWidth : CGFloat = 30
    let imageNameFish = "fish.jpeg"
    
    // flying cat
    var flyingCat : FlyingImg = FlyingImg(image: nil, direction: .zero)
    
    enum FlyButtonText : Int {
        case start, stop, other
        
        func simpleDescription() -> String {
            switch self {
            case .start:
                return "start fly"
            case .stop:
                return "stop fly"
            default:
                return "Wow"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startButton?.setTitle(FlyButtonText.start.simpleDescription(), for: .normal)
        textLabel?.text = "Flying cat"
        flyingCat.image = catImg
    }

    @IBAction func didTapStart() {
        var title : FlyButtonText
        if !isFlyState {
            // button work
            title = FlyButtonText.stop
            
            // fly direction init
            let xRandom : CGFloat = CGFloat.random(in: -1...1) * flySpeed
            let yRandom : CGFloat = CGFloat.random(in: -1...1) * flySpeed
            flyingCat.direction = CGPoint(x: xRandom, y: yRandom)
            
            //timer turn on
            if (switchButton?.isOn)! {
                // chaos
                timerFly = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(moveImgChaosAll), userInfo: nil, repeats: true)
            } else {
                // circle
                flyingCat.image?.center = CGPoint(x: (flyingCat.image?.superview?.bounds.width)! / 2 + radius - 1, y: (flyingCat.image?.superview?.bounds.height)! / 2)
                timerFly = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(moveImgCircle), userInfo: nil, repeats: true)
            }
        } else {
            // button work
            title = FlyButtonText.start
            
            //timer turn off
            timerFly?.invalidate()
            timerFly = nil
            
            // delete fish
            clearFishArray()
        }
        
        // change button state
        startButton?.setTitle(title.simpleDescription(), for: .normal)
        isFlyState = !isFlyState
    }
    
    func clearFishArray() {
        for fish in flyingFish {
            fish.image?.removeFromSuperview()
        }
        flyingFish.removeAll()
    }
    
    // image fly
    @objc func moveImgChaosAll() {
        // fly cat
        moveImgChaos(flyingImg: &flyingCat)
        
        //fly fish
        var deletedFish : [Int] = []
        for i in 0..<flyingFish.count {
            moveImgChaos(flyingImg: &flyingFish[i])
            // fix collision between cat end fish
            if isImagesCollision(cat: flyingCat.image!, fish: flyingFish[i].image!) {
                // change cat direction
                if (flyingCat.image?.frame.minX)! - (flyingFish[i].image?.frame.maxX)! <= error  || (flyingFish[i].image?.frame.minX)! - (flyingCat.image?.frame.maxX)! <= error {
                    flyingCat.direction.x = -1 * flyingCat.direction.x
                }
                
                if (flyingCat.image?.frame.minY)! - (flyingFish[i].image?.frame.maxY)! <= error  || (flyingFish[i].image?.frame.minY)! - (flyingCat.image?.frame.maxY)! <= error {
                    flyingCat.direction.y = -1 * flyingCat.direction.y
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
    
    func moveImgChaos(flyingImg: inout FlyingImg) {
        flyingImg.image?.center = CGPoint(x: (flyingImg.image?.center.x)! + flyingImg.direction.x, y: (flyingImg.image?.center.y)! + flyingImg.direction.y)
        fixImgBoundsdCollision(flyingImg: &flyingImg)
    }
    
    @objc func moveImgCircle() {
        let coordinateX = (flyingCat.image?.superview?.bounds.width)! / 2 + radius * cos(angle)
        let coordinateY = (flyingCat.image?.superview?.bounds.height)! / 2 + radius * sin(angle)
        flyingCat.image?.center = CGPoint(x: coordinateX, y: coordinateY)
        
        angle += 0.01
        if angle >= 2 * CGFloat.pi {
            angle = 0
        }
    }
    
    // fix image boards collisions
    func fixImgBoundsdCollision(flyingImg: inout FlyingImg) {
        // x bound
        if (flyingImg.image?.frame.minX)! <= error  || (flyingImg.image?.superview?.bounds.width)! - (flyingImg.image?.frame.maxX)! <= error {
            flyingImg.direction.x = -1 * flyingImg.direction.x
        }
        
        //y bound
        if (flyingImg.image?.frame.minY)! <= error  || (flyingImg.image?.superview?.bounds.height)! - (flyingImg.image?.frame.maxY)! <= error {
            flyingImg.direction.y = -1 * flyingImg.direction.y
        }
    }
    
    // fix images collision
    func isImagesCollision(cat: UIView, fish: UIView) -> Bool {
        // first up/down
        if abs(fish.center.x - cat.center.x) < (cat.bounds.width + fish.bounds.width) / 2 &&
            abs(fish.center.y - cat.center.y) < (cat.bounds.height + fish.bounds.height) / 2 {
            return true
        }
        return false
    }
    
    // create fish
    @IBAction func createFish() {
        if isFlyState || !(switchButton?.isOn)!{
            return
        }

        // fill using fish
        let fishNumber : Int? = Int((flyingFishNumber?.text)!)
        // if not a number
        if fishNumber == nil {
            return
        }
        
        let bounds = flyingCat.image?.superview?.bounds
        
        for _ in 0..<fishNumber! {
            var currentFish : FlyingImg = FlyingImg()
            
            // create image
            let image = UIImage(named: imageNameFish)
            let imageView = UIImageView(image: image!)
                
            //create frame
            let randomInitX : CGFloat = CGFloat.random(in: (fishWidth / 2)...((bounds?.width)! - fishWidth / 2))
            let randomInitY : CGFloat = CGFloat.random(in: (fishHeight / 2)...((bounds?.height)! - fishHeight / 2))
            imageView.frame = CGRect(x: randomInitX, y: randomInitY, width: fishWidth, height: fishHeight)
            currentFish.image? = imageView
            
            // generate direction
            let xRandom : CGFloat = CGFloat.random(in: -1...1)
            let yRandom : CGFloat = CGFloat.random(in: -1...1)
            currentFish.direction = CGPoint(x: xRandom, y: yRandom)
            
            // add picture
            flyingCat.image?.superview?.addSubview(currentFish.image!) // add into the frame with cat
            flyingFish.append(currentFish)
        }
    }
}

