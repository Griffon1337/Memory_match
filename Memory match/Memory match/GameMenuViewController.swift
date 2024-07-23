//
//  GameMenuViewController.swift
//  Memory match
//
//  Created by Грифон on 20.07.24.
//

import UIKit
import SafariServices
import SpriteKit

class GameMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupButtons()
    }
    
    private func setupBackgroundImage() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "Menu")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    private func setupButtons() {
        let playButton = createButton(imageName: "Play_button", action: #selector(playNowTapped))
        let privacyButton = createButton(imageName: "Privacy_button", action: #selector(privacyPolicyTapped))
        let presentButton = createButton(imageName: "Present", action: #selector(presentTapped))
        
        view.addSubview(playButton)
        view.addSubview(privacyButton)
        view.addSubview(presentButton)
        
        setupButtonConstraints(playButton: playButton, privacyButton: privacyButton, presentButton: presentButton)
    }
    
    private func createButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupButtonConstraints(playButton: UIButton, privacyButton: UIButton, presentButton: UIButton) {
        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(equalToConstant: 200),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70),
            
            privacyButton.widthAnchor.constraint(equalToConstant: 120),
            privacyButton.heightAnchor.constraint(equalToConstant: 25),
            privacyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            
            presentButton.widthAnchor.constraint(equalToConstant: 50),
            presentButton.heightAnchor.constraint(equalToConstant: 50),
            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180),
        ])
    }
    
    @objc private func playNowTapped() {
        let gameViewController = GameViewController()
        transitionToViewController(gameViewController)
    }
    
    @objc private func privacyPolicyTapped() {
        guard let url = URL(string: "https://theideaslab.org/wp-content/uploads/2018/05/Privacy-policy-meme.jpg") else {
            print("Invalid URL")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @objc private func presentTapped() {
        let presentViewController = PresentViewController()
        presentViewController.modalPresentationStyle = .fullScreen
        present(presentViewController, animated: true)
    }
    
    private func transitionToViewController(_ viewController: UIViewController) {
        guard let window = view.window else {
            print("Window not found")
            return
        }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = viewController
        })
    }
}

