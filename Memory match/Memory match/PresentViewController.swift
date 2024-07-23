//
//  PresentViewController.swift
//  Memory match
//
//  Created by Грифон on 23.07.24.
//

import UIKit

class PresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButton()
        setupSkipLabel()
    }
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "Notifications")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    private func setupButton() {
        let agreeButton = UIButton(type: .custom)
        agreeButton.setBackgroundImage(UIImage(named: "Rect"), for: .normal)
        agreeButton.setTitle("Yes, I Want Bonuses!", for: .normal)
        agreeButton.setTitleColor(.black, for: .normal)
        agreeButton.titleLabel?.textAlignment = .center
        agreeButton.titleLabel?.numberOfLines = 0
        agreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(agreeButton)
        
        NSLayoutConstraint.activate([
            agreeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            agreeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            agreeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            agreeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupSkipLabel() {
        let skipLabel = UILabel()
        skipLabel.text = "Skip"
        skipLabel.textAlignment = .center
        skipLabel.textColor = .systemBlue
        skipLabel.font = UIFont.systemFont(ofSize: 16)
        skipLabel.translatesAutoresizingMaskIntoConstraints = false
        skipLabel.isUserInteractionEnabled = true
        skipLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(skipTapped)))
        
        view.addSubview(skipLabel)
        
        NSLayoutConstraint.activate([
            skipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func buttonTapped() {
        transitionToGameMenu()
    }
    
    @objc private func skipTapped() {
        transitionToGameMenu()
    }
    
    private func transitionToGameMenu() {
        let gameViewController = GameMenuViewController()
        if let window = view.window {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = gameViewController
            }, completion: nil)
        } else {
            print("Window not found")
        }
    }
}
