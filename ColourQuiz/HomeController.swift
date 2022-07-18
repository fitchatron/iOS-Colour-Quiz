//
//  HomeController.swift
//  ColourQuiz
//
//  Created by James Fitch on 5/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import UIKit
import SwiftUI
import LBTATools

class HomeController: UIViewController {
    
    //vars
    var highScore: Int = 0
    //NSUserDefaults
    fileprivate let defaults = UserDefaults.standard
    
    //UI elements
    let howToPlayButton: OptionButton = {
        let button = OptionButton(titleText: "How To Play")
        button.addTarget(self, action: #selector(handleHowToPlay), for: .touchUpInside)
        return button
    }()
    
    let playButton: OptionButton = {
        let button = OptionButton(titleText: "Play Now")
        button.addTarget(self, action: #selector(handlePlayNow), for: .touchUpInside)
        return button
    }()
    
    let highScoreLabel = UILabel(text: "Top Score: 13", font: .boldSystemFont(ofSize: 24), textColor: UIColor(named: "systemBlack") ?? .black, textAlignment: .left, numberOfLines: 1)
    
    let resetHighScoreButton: OptionButton = {
        let button = OptionButton(titleText: "Reset High Score")
        button.addTarget(self, action: #selector(handleResetHighScore), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        highScore = defaults.integer(forKey: "highScore")
        view.backgroundColor = .systemGray5
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Colour Match"
        
        view.stack(howToPlayButton, playButton, view.hstack(highScoreLabel, spacing: 8, distribution: .fillEqually), resetHighScoreButton, spacing: 64, distribution: .fillEqually).padTop(150).padLeft(64).padRight(64).padBottom(150)
        
        highScoreLabel.text = "High Score: \(highScore)"
    }
    
    @objc fileprivate func handlePlayNow() {
        let quizController = QuizController()
        navigationController?.pushViewController(quizController, animated: true)
    }
    
    @objc fileprivate func handleHowToPlay() {
        print("how to play")
    }
    
    @objc fileprivate func handleResetHighScore() {
        defaults.set(0, forKey: "highScore")
        highScoreLabel.text = "High Score: \(highScore)"
    }
}

struct HomeControllerPreview: PreviewProvider {
    
    static var previews: some View {
        ContentView().edgesIgnoringSafeArea(.all)
        //.environment(\.colorScheme, .dark)
    }
    
    struct ContentView: UIViewControllerRepresentable {
        typealias UIViewControllerType = HomeController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<HomeControllerPreview.ContentView>) -> HomeController {
            return HomeController()
        }
        
        func updateUIViewController(_ uiViewController: HomeController, context: UIViewControllerRepresentableContext<HomeControllerPreview.ContentView>) {
        }
    }
}


