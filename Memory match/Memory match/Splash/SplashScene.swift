import SpriteKit

class SplashScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupLogo()
        simulateResourceLoading()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "Splash")
        background.zPosition = -1
        
        let textureSize = background.texture!.size()
        let viewSize = self.size
        let scaleFactor = max(viewSize.width / textureSize.width, viewSize.height / textureSize.height)
        
        background.size = CGSize(width: textureSize.width * scaleFactor, height: textureSize.height * scaleFactor)
        background.position = CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
        
        self.addChild(background)
    }
    
    private func setupLogo() {
        let logo = SKSpriteNode(imageNamed: "Fire")
        logo.position = CGPoint(x: self.size.width / 2, y: -logo.size.height / 2) //
        self.addChild(logo)
        
        let moveUp = SKAction.moveTo(y: self.size.height + logo.size.height / 2, duration: 2.0)
        let resetPosition = SKAction.moveTo(y: -logo.size.height / 2, duration: 0)
        let sequence = SKAction.sequence([moveUp, resetPosition])
        let repeatAction = SKAction.repeatForever(sequence)
        
        logo.run(repeatAction)
    }
    
    private func simulateResourceLoading() {
        loadResources {
            self.transitionToGameMenu()
        }
    }
    
    private func transitionToGameMenu() {
        guard let window = self.view?.window else {
            print("Window not found")
            return
        }
        
        let gameMenuVC = GameMenuViewController()
        window.rootViewController = gameMenuVC
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    private func loadResources(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            // simulate loading app for check loading animation
            // sleep(4)
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
