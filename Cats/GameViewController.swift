//
//  GameViewController.swift
//  Cats
//
//  Created by Toro Roan on 9/9/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreMotion

class GameViewController: UIViewController {
    var motionManager: CMMotionManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have a motion manager \(manager)")
            if manager.isDeviceMotionAvailable {
                print("We can detect motion!")
                let myq = OperationQueue()
                manager.deviceMotionUpdateInterval = 1
                manager.startDeviceMotionUpdates(to: myq){
                    (data: CMDeviceMotion?, error: Error?) in
                    if let mydata = data {
                        let attitude = mydata.attitude
                        print("pitch", self.degrees(radians: attitude.pitch))
                        print("Roll", self.degrees(radians: attitude.roll))
                        
                    }
                }
            }
            else {
                print("We cannot detect motion")
            }
        }
        else {
            print("No manager")
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func degrees(radians: Double) -> Double {
        return 180/Double.pi * radians
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
