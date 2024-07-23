import UIKit
import SpriteKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSKView()
    }
    
    private func setupSKView() {
        let skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let splashScene = SplashScene(size: skView.bounds.size)
        splashScene.scaleMode = .aspectFill
        skView.presentScene(splashScene)
    }
}
