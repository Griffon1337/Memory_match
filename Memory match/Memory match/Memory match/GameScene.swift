//  GameScene.swift
//  Memory match
//
//  Created by Грифон on 20.07.24.
//
import SpriteKit

class GameScene: SKScene {
    
    private var cardNodes = [SKSpriteNode]()
    private var firstCard: SKSpriteNode?
    private var secondCard: SKSpriteNode?
    private var isCheckingMatch = false
    private var isFlipping = false
    private var isPausedGame = false

    private let cardWidth: CGFloat = 100
    private let cardHeight: CGFloat = 100
    private let cardSpacing: CGFloat = 10
    private let rows = 4
    private let cols = 4
    
    private let backTexture = SKTexture(imageNamed: "Slot_Back")
    
    private var movesLabel: SKLabelNode!
    private var timeLabel: SKLabelNode!
    private var moveCount = 0
    private var startTime: TimeInterval = 0
    private var pausedTime: TimeInterval = 0
    private var timer: Timer?
    
    private var settingsButton: SKSpriteNode!
    private var refreshButton: SKSpriteNode!
    private var backButton: SKSpriteNode!
    private var pauseButton: SKSpriteNode!
    private var playButton: SKSpriteNode!
    private var pauseLabel: SKLabelNode!
    
    private var allCardsMatched = false
    override func didMove(to view: SKView) {
        setupGame()
        setupScoreLabel()
        setupTimeLabel()
        startTimer()
        setupButtons()
        setupPauseLabel()
    }
    
    private func setupGame() {
        let cardImages = [
            SKTexture(imageNamed: "Slot_1"),
            SKTexture(imageNamed: "Slot_2"),
            SKTexture(imageNamed: "Slot_3"),
            SKTexture(imageNamed: "Slot_4"),
            SKTexture(imageNamed: "Slot_5"),
            SKTexture(imageNamed: "Slot_6"),
            SKTexture(imageNamed: "Slot_7"),
            SKTexture(imageNamed: "Slot_8")
        ]
        
        var cardTextures = cardImages + cardImages
        cardTextures.shuffle()
        
        for row in 0..<rows {
            for col in 0..<cols {
                let card = SKSpriteNode(texture: backTexture, size: CGSize(width: cardWidth, height: cardHeight))
                card.position = CGPoint(
                    x: CGFloat(col) * (cardWidth + cardSpacing) - (CGFloat(cols) * (cardWidth + cardSpacing) / 2) + cardWidth / 2,
                    y: CGFloat(row) * (cardHeight + cardSpacing) - (CGFloat(rows) * (cardHeight + cardSpacing) / 2) + cardHeight / 2)
                
                card.name = "card_\(row)_\(col)"
                card.zPosition = 1
                
                let cardTexture = cardTextures.removeFirst()
                card.userData = NSMutableDictionary()
                card.userData?.setValue(cardTexture, forKey: "frontTexture")
                card.userData?.setValue(backTexture, forKey: "backTexture")
                
                addChild(card)
                cardNodes.append(card)
            }
        }
    }
    
    private func setupScoreLabel() {
        if let scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode {
            movesLabel = scoreLabel
            movesLabel.text = "Moves: \(moveCount)"
        } else {
            print("ScoreLabel not found in the scene")
        }
    }
    
    private func setupTimeLabel() {
        if let timeLabel = childNode(withName: "timeLabel") as? SKLabelNode {
            self.timeLabel = timeLabel
            updateTimeLabel()
        } else {
            print("timeLabel not found in the scene")
        }
    }
    
    private func setupButtons() {
        if let settingsBtn = childNode(withName: "settingsBtn") as? SKSpriteNode {
            settingsButton = settingsBtn
        } else {
            print("refreshBtn not found in the scene")
        }
        if let refreshBtn = childNode(withName: "refreshBtn") as? SKSpriteNode {
            refreshButton = refreshBtn
        } else {
            print("refreshBtn not found in the scene")
        }
        if let backBtn = childNode(withName: "backBtn") as? SKSpriteNode {
            backButton = backBtn
        } else {
            print("backBtn not found in the scene")
        }
        if let pauseBtn = childNode(withName: "pauseBtn") as? SKSpriteNode {
            pauseButton = pauseBtn
        } else {
            print("pauseBtn not found in the scene")
        }
        if let playBtn = childNode(withName: "playBtn") as? SKSpriteNode {
            playButton = playBtn
            playButton.isHidden = true
        } else {
            print("playBtn not found in the scene")
        }
    }

    private func setupPauseLabel() {
        pauseLabel = SKLabelNode(text: "PAUSE")
        pauseLabel.fontSize = 65
        pauseLabel.fontColor = .white
        pauseLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseLabel.zPosition = 2
        pauseLabel.isHidden = true
        addChild(pauseLabel)
    }
    
    private func startTimer() {
        startTime = NSDate().timeIntervalSince1970 - pausedTime
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTimeLabel()
        }
    }
    
    private func updateTimeLabel() {
        let currentTime = NSDate().timeIntervalSince1970
        let elapsedTime = currentTime - startTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timeLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    private func restartGame() {
        let gameViewController = GameViewController()
        if let window = self.view?.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = gameViewController
            }, completion: nil)
        } else {
            print("Window not found")
        }
    }
    
    
    
    private func goToMainMenu() {
        let gameViewController = GameMenuViewController()
        if let window = self.view?.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = gameViewController
            }, completion: nil)
        } else {
            print("Window not found")
        }
    }
    
    private func pauseGame() {
        isPausedGame = true
        pausedTime = NSDate().timeIntervalSince1970 - startTime
        timer?.invalidate()
        pauseButton.isHidden = true
        playButton.isHidden = false
        pauseLabel.isHidden = false
    }
    
    private func resumeGame() {
        isPausedGame = false
        startTime = NSDate().timeIntervalSince1970 - pausedTime
        startTimer()
        pauseButton.isHidden = false
        playButton.isHidden = true
        pauseLabel.isHidden = true
    }
    
    private func checkGameCompletion() {
        if cardNodes.allSatisfy({ $0.texture != backTexture }) {
            allCardsMatched = true
            showWinScreen()
        }
    }
    
    private func showWinScreen() {
        let winTexture = SKTexture(imageNamed: "Win")
        let winNode = SKSpriteNode(texture: winTexture)
        
        timer?.invalidate()

        winNode.size = self.size
        winNode.position = CGPoint(x: frame.midX, y: frame.midY)
        winNode.zPosition = 2
        addChild(winNode)
        
        let isVibroOn = UserDefaults.standard.bool(forKey: "vibroSwitchOn")
            if isVibroOn {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        
        let isMusicOn = UserDefaults.standard.bool(forKey: "musicSwitchOn")
            if isMusicOn {
                run(SKAction.playSoundFileNamed("win", waitForCompletion: false))
            }
        
        let resultLabel = SKLabelNode(text: "Moves: \(moveCount) \(timeLabel.text ?? "00:00")")
        
        resultLabel.fontSize = 30
        resultLabel.fontName = "Gill Sans SemiBold"
        resultLabel.fontColor = .white
        resultLabel.position = CGPoint(x: frame.midX, y: frame.midY - 160)
        resultLabel.zPosition = 3
        
        winNode.addChild(resultLabel)
        
        let restartButton = SKSpriteNode(imageNamed: "Refresh")
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: frame.midX - 40, y: frame.midY - 300)
        restartButton.zPosition = 3
        restartButton.size = CGSize(width: 70, height: 70)

        winNode.addChild(restartButton)
        
        let menuButton = SKSpriteNode(imageNamed: "Back")
        menuButton.name = "menuButton"
        menuButton.position = CGPoint(x: frame.midX + 40 , y: frame.midY - 300)
        menuButton.zPosition = 3
        menuButton.size = CGSize(width: 70, height: 70)
        
        winNode.addChild(menuButton)

        for card in cardNodes {
            card.removeFromParent()
        }
    }
    
    private func goToSettings() {
        let settingsTexture = SKTexture(imageNamed: "SettingsView")
        let settingsNode = SKSpriteNode(texture: settingsTexture)

        settingsNode.size = self.size
        settingsNode.position = CGPoint(x: frame.midX, y: frame.midY)
        settingsNode.zPosition = 2
        settingsNode.name = "settingsNode"
        
        addChild(settingsNode)
        
        let settingVibroLabel = SKLabelNode(text: "Vibration")
        settingVibroLabel.fontSize = 40
        settingVibroLabel.fontName = "Gill Sans SemiBold"
        settingVibroLabel.fontColor = .white
        settingVibroLabel.position = CGPoint(x: frame.midX + 90, y: frame.midY + 150)
        settingVibroLabel.zPosition = 3
        
        settingsNode.addChild(settingVibroLabel)
        
        let settingMusicLabel = SKLabelNode(text: "Music")
        settingMusicLabel.fontSize = 40
        settingMusicLabel.fontName = "Gill Sans SemiBold"
        settingMusicLabel.fontColor = .white
        settingMusicLabel.position = CGPoint(x: frame.midX - 90, y: frame.midY + 150)
        settingMusicLabel.zPosition = 3
        settingsNode.addChild(settingMusicLabel)
        
        let buttonMusicName = UserDefaults.standard.bool(forKey: "musicSwitchOn") ? "MusicOn" : "MusicOff"
        let musicBtn = SKSpriteNode(imageNamed: buttonMusicName)
        musicBtn.name = "musicSwitchButton"
        musicBtn.position = CGPoint(x: frame.midX - 90, y: frame.midY + 100)
        musicBtn.zPosition = 3
        musicBtn.size = CGSize(width: 70, height: 70)

        settingsNode.addChild(musicBtn)
        
        let buttonVibroName = UserDefaults.standard.bool(forKey: "vibroSwitchOn") ? "VibroOn" : "VibroOff"
        let vibroBtn = SKSpriteNode(imageNamed: buttonVibroName)
        vibroBtn.name = "vibroSwitchButton"
        vibroBtn.position = CGPoint(x: frame.midX + 90 , y: frame.midY + 100)
        vibroBtn.zPosition = 3
        vibroBtn.size = CGSize(width: 70, height: 70)
        
        settingsNode.addChild(vibroBtn)
        
        let closeBtn = SKSpriteNode(imageNamed: "Close")
        closeBtn.name = "closeButton"
        closeBtn.position = CGPoint(x: frame.midX, y: frame.midY - 300)
        closeBtn.zPosition = 3
        closeBtn.size = CGSize(width: 70, height: 70)
        
        settingsNode.addChild(closeBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, !isCheckingMatch, !isFlipping else { return }
        
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let nodeName = touchedNode.name {
            if nodeName == "backBtn" {
                goToMainMenu()
                return
            } else if nodeName == "refreshBtn" {
                restartGame()
                return
            } else if nodeName == "pauseBtn" {
                pauseGame()
                return
            } else if nodeName == "playBtn" {
                resumeGame()
                return
            } else if nodeName == "restartButton" {
                restartGame()
                return
            } else if nodeName == "menuButton" {
                goToMainMenu()
                return
            } else if nodeName == "settingsBtn" {
                goToSettings()
                return
            } else if nodeName == "musicSwitchButton" {
                toggleMusic()
                return
            } else if nodeName == "vibroSwitchButton" {
                toggleVibro()
                return
            } else if nodeName == "closeButton" {
                closeSettings()
                return
        }
    }
        if isPausedGame { return }
        
        if let card = touchedNode as? SKSpriteNode, card.texture == backTexture {
            handleCardSelection(card)
        }
    }
    
    private func closeSettings() {
        if let settingsNode = self.childNode(withName: "settingsNode") {
            settingsNode.removeFromParent()
        }
    }
    
    private func toggleVibro() {
        if let settingsNode = self.childNode(withName: "settingsNode"),
           let vibroBtn = settingsNode.childNode(withName: "vibroSwitchButton") as? SKSpriteNode {
            let isVibroOn = UserDefaults.standard.bool(forKey: "vibroSwitchOn")
            let newTextureName = isVibroOn ? "VibroOff" : "VibroOn"
            let newTexture = SKTexture(imageNamed: newTextureName)
            
            vibroBtn.texture = newTexture
            
            UserDefaults.standard.set(!isVibroOn, forKey: "vibroSwitchOn")
        }else {
            print("Button not found")
        }
    }
    
    private func toggleMusic() {
        if let settingsNode = self.childNode(withName: "settingsNode"),
           let musicBtn = settingsNode.childNode(withName: "musicSwitchButton") as? SKSpriteNode {
            let isMusicOn = UserDefaults.standard.bool(forKey: "musicSwitchOn")
            let newTextureName = isMusicOn ? "MusicOff" : "MusicOn"
            let newTexture = SKTexture(imageNamed: newTextureName)
            
            musicBtn.texture = newTexture
            
            UserDefaults.standard.set(!isMusicOn, forKey: "musicSwitchOn")
        }else {
            print("Button not found")
        }
    }
    
    private func handleCardSelection(_ card: SKSpriteNode) {
        guard !isCheckingMatch, !isFlipping, card != firstCard, card != secondCard else { return }
        
        if firstCard == nil {
            flipCard(card, to: card.userData?.value(forKey: "frontTexture") as! SKTexture) { [weak self] in
                self?.firstCard = card
            }
            
            let isVibroOn = UserDefaults.standard.bool(forKey: "vibroSwitchOn")
            if isVibroOn {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            let isMusicOn = UserDefaults.standard.bool(forKey: "musicSwitchOn")
            if isMusicOn {
                run(SKAction.playSoundFileNamed("card_flip", waitForCompletion: false))
                
            }
        } else if secondCard == nil {
            flipCard(card, to: card.userData?.value(forKey: "frontTexture") as! SKTexture) { [weak self] in
                self?.secondCard = card
                
                self?.checkForMatch()
            }
            
            let isVibroOn = UserDefaults.standard.bool(forKey: "vibroSwitchOn")
            if isVibroOn {
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            let isMusicOn = UserDefaults.standard.bool(forKey: "musicSwitchOn")
            if isMusicOn {
                run(SKAction.playSoundFileNamed("card_flip", waitForCompletion: false))
                
            }
        }
    }
    
    private func checkForMatch() {
        guard let firstCard = firstCard, let secondCard = secondCard else { return }
        
        isCheckingMatch = true
        
        let firstTexture = firstCard.userData?.value(forKey: "frontTexture") as! SKTexture
        let secondTexture = secondCard.userData?.value(forKey: "frontTexture") as! SKTexture
        
        if firstTexture == secondTexture {
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.firstCard = nil
                self.secondCard = nil
                self.isCheckingMatch = false
                self.checkGameCompletion()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
                self.flipCardBack(self.firstCard!) {
                    self.flipCardBack(self.secondCard!) {
                        self.firstCard = nil
                        self.secondCard = nil
                        self.isCheckingMatch = false
                    }
                }
            }
        }
        
        moveCount += 1
        movesLabel.text = "Moves: \(moveCount)"
    }
    
    private func flipCard(_ card: SKSpriteNode, to newTexture: SKTexture, completion: @escaping () -> Void) {
        isFlipping = true
        let flipAction = SKAction.sequence([
            SKAction.scale(to: CGSize(width: card.size.width * 0.01, height: card.size.height), duration: 0.2),
            SKAction.run { card.texture = newTexture },
            SKAction.scale(to: card.size, duration: 0.2),
            SKAction.run {
                self.isFlipping = false
                completion()
            }
        ])
        
        card.run(flipAction)
    }
    
    private func flipCardBack(_ card: SKSpriteNode, completion: @escaping () -> Void) {
        isFlipping = true
        let flipAction = SKAction.sequence([
            SKAction.scale(to: CGSize(width: card.size.width * 0.01, height: card.size.height), duration: 0.2),
            SKAction.run { card.texture = self.backTexture },
            SKAction.scale(to: card.size, duration: 0.2),
            SKAction.run {
                self.isFlipping = false
                completion()
            }
        ])
        
        card.run(flipAction)
    }
    
    deinit {
        timer?.invalidate()
    }
}
