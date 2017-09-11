//
//  GameOverScene.swift
//  Cats
//
//  Created by Toro Roan on 9/10/17.
//  Copyright © 2017 Toro Roan. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        //create label
        super.init(size: size)
        backgroundColor = SKColor.black
        
        let message = won ? "Cat Escape!" : "Oops!"
        
        let label = SKLabelNode(fontNamed: "Chalkboard SE")
        label.text = message
        label.fontSize = 73
        label.fontColor = SKColor.white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                
                self.viewDidLoad()
            }
            ]))
        
    }
    
    
//    override func didMove(to view: SKView) {
//        //create button
//        let btn:UIButton = UIButton(frame: CGRect(x: size.width/2, y: size.height/2, width: 100, height: 50))
//        btn.setTitle("Start Over", for: .normal)
//        btn.setTitleColor(UIColor.blue, for: .normal)
//        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
//        btn.tag = 1
//        self.view?.addSubview(btn)
//    }
    
    func viewDidLoad() {
       
        if let view = self.view {
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
    
    func goToGameScene(){
        let gameScene:GameScene = GameScene(size: self.size)
        let transition = SKTransition.fade(withDuration: 1.0) // create type of
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
        
    }
    func buttonAction(sender: UIButton){
        goToGameScene()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
