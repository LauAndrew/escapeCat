//
//  GameScene.swift
//  Cats
//
//  Created by Toro Roan on 9/9/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var cat: SKSpriteNode?
    let cat_speed: Double = 2.0
    var dogs: [SKSpriteNode?] = []
    let dog_speed: CGFloat = 2.0
    var motionManager: CMMotionManager?
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
            
        view.showsFPS = false
        view.showsNodeCount = false
        
        //setup Collision detection
        physicsWorld.contactDelegate = self

        // Setup Cat
        cat = self.childNode(withName: "muffin") as? SKSpriteNode
        
        // Setup Dog
        for child in self.children {
            if child.name == "marco" {
                if let child = child as? SKSpriteNode {
                    dogs.append(child)
                }
            }
        }
        
        // Set up BMG
        self.playBacgroundMusic()
        
        
        //control cat
        
        motionManager = CMMotionManager()
        if let manager = motionManager {
            if manager.isDeviceMotionAvailable {
                let myq = OperationQueue()
                manager.startDeviceMotionUpdates(to: myq){
                    (data: CMDeviceMotion?, error: Error?) in
                    let attitude = data?.attitude
                    let roll = attitude?.roll
                    let pitch = attitude?.pitch
                    self.physicsWorld.gravity = CGVector(dx: pitch! * self.cat_speed, dy: roll! * self.cat_speed)
                    
                    
                    //move dog towards cat
                    for dog in self.dogs{
                        let dx = (self.cat?.position.x)! - (dog?.position.x)!
                        let dy = (self.cat?.position.y)! - (dog?.position.y)!
                        if dx < 10 || dy < 10 {
                            let angle = atan2(dy, dx)
                            //print("angle : ", self.degrees(radians: Double(angle)))
                            //dog?.yScale = -0.5
                            //dog?.zRotation = angle

                            let vx = cos(angle) * self.dog_speed
                            let vy = sin(angle) * self.dog_speed
                        
                            dog?.position.x += vx
                            dog?.position.y += vy
                        }
                        
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
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    func degrees(radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
    func playBacgroundMusic(){
        let aSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bmg", ofType: "mp3")!)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: aSound as URL)
            audioPlayer?.numberOfLoops = -1 //loop
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func gameOver(won: Bool){
        audioPlayer?.stop()
        let reveal = SKTransition.fade(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: won)
        self.view?.presentScene(gameOverScene, transition: reveal)
        
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 2{
            gameOver(won: false)
        }
        else if firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 3{
            gameOver(won: true)
        }
    }
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
