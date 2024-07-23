//
//  GameViewController.swift
//  Memory match
//
//  Created by Грифон on 20.07.24.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
    }
    
    private func setupSKView() {
        
        let skView = SKView(frame: view.bounds)
        view = skView
        
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        } else {
            print("Failed to load GameScene")
        }
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }
    
    override var prefersStatusBarHidden: Bool {
        true
    }
}
