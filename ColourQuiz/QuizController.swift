//
//  QuizController.swift
//  ColourQuiz
//
//  Created by James Fitch on 4/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import UIKit
import SwiftUI
import LBTATools

class QuizController: UIViewController {
    
    //vars
    var highScore: Int = 0
    var score: Int = 0
    var lives: Int = 3
    var timeLeft: Int = 5
    var timer = Timer()
    let quizCheck = QuizCheck(rightAnswer: 0, wrongAnswer: 0, noWrongAnswer: false)
    let colourArray = ["Black", "White", "Red", "Blue", "Yellow", "Green", "Orange", "Purple", "Pink", "Indigo", "Teal", "Gray"]
    var isGamePaused = false
    //NSUserDefaults
    fileprivate let defaults = UserDefaults.standard
    
    //UI elements
    let highScoreLabel = UILabel(text: "Top Score: 838", font: .boldSystemFont(ofSize: 22), textColor: UIColor(named: "systemBlack") ?? .black, textAlignment: .left, numberOfLines: 1)
    let scoreLabel = UILabel(text: "Score: 1", font: .boldSystemFont(ofSize: 22), textColor: UIColor(named: "systemBlack") ?? .black, textAlignment: .left, numberOfLines: 1)
    let livesLabel = UILabel(text: "Lives: 3", font: .boldSystemFont(ofSize: 22), textColor: UIColor(named: "systemBlack") ?? .black, textAlignment: .left, numberOfLines: 1)
    let timeRemainingLabel = UILabel(text: "Time Left:\n5 Seconds", font: .boldSystemFont(ofSize: 24), textColor: UIColor(named: "systemBlack") ?? .black, textAlignment: .left, numberOfLines: 2)
    
    let quizWord = UILabel(text: "Gray", font: .boldSystemFont(ofSize: 96), textColor: .systemGray2, textAlignment: .center, numberOfLines: 1)
    
    let leftButton: RoundedQuizButton = {
        let button = RoundedQuizButton(colour: .systemGray2)
        button.tag = 0
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        return button
    }()
    
    let rightButton: RoundedQuizButton = {
        let button = RoundedQuizButton(colour: .systemGray2)
        button.tag = 1
        button.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        return button
    }()
    
    let pauseButton: OptionButton = {
        let button = OptionButton(titleText: "Pause")
        button.addTarget(self, action: #selector(handlePauseGame), for: .touchUpInside)
        return button
    }()
    
    let endGameButton: OptionButton = {
        let button = OptionButton(titleText: "End Game")
        button.addTarget(self, action: #selector(handleEndGame), for: .touchUpInside)
        return button
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }

        if traitCollection.userInterfaceStyle == .light {
            leftButton.layer.borderColor = UIColor.black.cgColor
            rightButton.layer.borderColor = UIColor.black.cgColor
        } else {
            leftButton.layer.borderColor = UIColor.white.cgColor
            rightButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highScore = defaults.integer(forKey: "highScore")
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setLabelValues()
        playGame()
    }
    
    fileprivate func setupLayout() {
        
        let screenWidth = view.frame.width
        let roundedButtonWidth = (screenWidth - 98) / 2
        
        quizWord.adjustsFontSizeToFitWidth = true
        
        [leftButton, rightButton].forEach { (button) in
            button.constrainWidth(roundedButtonWidth)
            button.constrainHeight(roundedButtonWidth)
            button.layer.cornerRadius = roundedButtonWidth / 2
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Now Playing"
        navigationItem.hidesBackButton = true
        
        let labelsContainer = UIView(backgroundColor: .clear)
        let quizWordContainer = UIView(backgroundColor: .clear)
        let buttonContainer = UIView(backgroundColor: .clear)
        let leftLabelContainer = UIView(backgroundColor: .clear)
        let rightLabelContainer = UIView(backgroundColor: .clear)
        
        view.backgroundColor = .systemGray5
        view.addSubview(labelsContainer)
        view.addSubview(quizWordContainer)
        view.addSubview(buttonContainer)
        
        view.stack(
            labelsContainer.hstack(
                leftLabelContainer.stack(
                    highScoreLabel,
                    scoreLabel,
                    livesLabel, spacing: 12, distribution: .fillEqually),
                rightLabelContainer.stack(
                    timeRemainingLabel,
                    UIView(), alignment: .trailing), spacing: 14),
            quizWordContainer.stack(
                UIView(),
                quizWord,
                UIView(), alignment: .center, distribution: .fill),
            buttonContainer.hstack(
                leftButton,
                rightButton, spacing: 36, distribution: .fillEqually), spacing: 24, distribution: .fill).padTop(36).padBottom(120).padLeft(32).padRight(32)
        
        view.addSubview(pauseButton)
        view.addSubview(endGameButton)
        
        pauseButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 6, right: 36), size: .init(width: 100, height: 50))
        
        endGameButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 36, bottom: 6, right: 0), size: .init(width: 100, height: 50))
    }
    
    fileprivate func setLabelValues() {
        highScoreLabel.text = "High Score: \(highScore)"
        scoreLabel.text = "Score: \(score)"
        livesLabel.text = "Lives: \(lives)"
        timeRemainingLabel.text = "Time Left:\n\(timeLeft) Seconds"
    }
    
    fileprivate func fireTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleUpdateTimer), userInfo: nil, repeats: true)
    }
    
    fileprivate func playGame() {
        setQuizWord()
        fireTimer()
    }
    
    fileprivate func setQuizWord() {
        let colourOne = Int.random(in: 0..<colourArray.count)
        let colourTwo = Int.random(in: 0..<colourArray.count)
        let position =  Int.random(in: 0..<2)
        
        //set quizWord text colour off colour 1
        switch colourOne {
        case 0:
            quizWord.textColor = .black
        case 1:
            quizWord.textColor = .white
        case 2:
            quizWord.textColor = .red
        case 3:
            quizWord.textColor = .systemBlue
        case 4:
            quizWord.textColor = .yellow
        case 5:
            quizWord.textColor = .systemGreen
        case 6:
            quizWord.textColor = .orange
        case 7:
            quizWord.textColor = .systemPurple
        case 8:
            quizWord.textColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        case 9:
            quizWord.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case 10:
            quizWord.textColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 11:
            quizWord.textColor = .systemGray2
        default:
            quizWord.textColor = .gray
        }
        
        //set quizWord text off colour 2
        quizWord.text = colourArray[colourTwo]
        
        //set which button gets which colour and thus which is the right and wrong answer
        if position == 0 {
            setQuizButtons(button: leftButton, colour: colourOne)
            setQuizButtons(button: rightButton, colour: colourTwo)
            quizCheck.rightAnswer = 1
            quizCheck.wrongAnswer = 0
            quizCheck.noWrongAnswer = false
        } else {
            setQuizButtons(button: leftButton, colour: colourTwo)
            setQuizButtons(button: rightButton, colour: colourOne)
            quizCheck.rightAnswer = 0
            quizCheck.wrongAnswer = 1
            quizCheck.noWrongAnswer = false
        }
        
        if colourOne == colourTwo {
            quizCheck.noWrongAnswer = true
        }
        
    }
    
    fileprivate func setQuizButtons(button: RoundedQuizButton, colour: Int) {
        switch colour {
        case 0:
            button.backgroundColor = .black
        case 1:
            button.backgroundColor = .white
        case 2:
            button.backgroundColor = .red
        case 3:
            button.backgroundColor = .systemBlue
        case 4:
            button.backgroundColor = .yellow
        case 5:
            button.backgroundColor = .systemGreen
        case 6:
            button.backgroundColor = .orange
        case 7:
            button.backgroundColor = .systemPurple
        case 8:
            button.backgroundColor = #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1)
        case 9:
            button.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case 10:
            button.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case 11:
            button.backgroundColor = .systemGray2
        default:
            button.backgroundColor = .gray
        }
    }
    
    fileprivate func rightAnswer() {
        print("right answer")
        setTimeLeftValue()
        score += 1
        setLabelValues()
        playGame()
    }
    
    fileprivate func wrongAnswer() {
        print("wrong answer")
        if timer.isValid {
            timer.invalidate()
        }
        setTimeLeftValue()
        lives -= 1
        setLabelValues()
        //if there are still lives then play again or game over
        if lives > 0 {
            playGame()
        } else {
            gameOver()
        }
    }
    
    fileprivate func gameOver() {
        print("game over")
        let alert = UIAlertController(title: "Game Over", message: "Nice Work. You got \(score) correct", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            print("OK")
        }))
        self.present(alert, animated: true)
        
        if score > highScore {
            highScore = score
            highScoreLabel.text = "High Score: \(highScore)"
            defaults.set(score, forKey: "highScore")
        }
        
        setQuizButtons(button: leftButton, colour: -1)
        setQuizButtons(button: rightButton, colour: -1)
        
        navigationItem.hidesBackButton = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
        pauseButton.isEnabled = false
        pauseButton.alpha = 0.5
        
        endGameButton.removeTarget(nil, action: nil, for: .allEvents)
        endGameButton.addTarget(self, action: #selector(handlePlayAgain), for: .touchUpInside)
        endGameButton.setTitle("Play Again", for: .normal)
    }
    
    fileprivate func setTimeLeftValue() {
        switch score {
        case _ where score < 15:
            timeLeft = 5
        case _ where score < 25:
            timeLeft = 4
        case _ where score < 45:
            timeLeft = 3
        case _ where score < 70:
            timeLeft = 2
        case _ where score < 5000:
            timeLeft = 1
        default:
            print("this is impossible")
            fatalError()
        }
    }
    
    @objc fileprivate func handlePauseGame() {
        print("Pause")
        isGamePaused.toggle()
        if isGamePaused {
            timer.invalidate()
            let pauseView = PauseView()
            view.addSubview(pauseView)
        } else {
            fireTimer()
        }
    }
    
    @objc fileprivate func handleEndGame() {
        print("end game")
        timer.invalidate()
        lives = 0
        setLabelValues()
        gameOver()
    }
    
    @objc fileprivate func handlePlayAgain() {
        print("Play Again")
        score = 0
        lives = 3
        setTimeLeftValue()
        setLabelValues()
        playGame()
        
        navigationItem.hidesBackButton = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
        pauseButton.isEnabled = true
        pauseButton.alpha = 1
        
        endGameButton.removeTarget(nil, action: nil, for: .allEvents)
        endGameButton.addTarget(self, action: #selector(handleEndGame), for: .touchUpInside)
        endGameButton.setTitle("End Game", for: .normal)
    }
    
    @objc fileprivate func handleTapButton(sender: RoundedQuizButton) {
        
        let tag = sender.tag
        
        //stop timer
        timer.invalidate()
        
        //reset time off vars and UI
        timeLeft = 10
        timeRemainingLabel.text = "Time Left:\n\(timeLeft) Seconds"
        
        if tag == quizCheck.rightAnswer || quizCheck.noWrongAnswer {
            //if right increase score and play again
            rightAnswer()
        } else {
            //if wrong take away life
            wrongAnswer()
        }
    }
    
    @objc fileprivate func handleUpdateTimer() {
        timeLeft -= 1
        setLabelValues()
        if timeLeft == 0 {
            wrongAnswer()
        }
    }
}

struct QuizControllerPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        //.environment(\.colorScheme, .dark)
        //.previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = QuizController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<QuizControllerPreview.ContainerView>) -> QuizController {
            return QuizController()
        }
        
        func updateUIViewController(_ uiViewController: QuizController, context: UIViewControllerRepresentableContext<QuizControllerPreview.ContainerView>) {
        }
    }
}
