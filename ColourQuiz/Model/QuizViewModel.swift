//
//  QuizViewModel.swift
//  ColourQuiz
//
//  Created by James Fitch on 17/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var highScore: Int = 0
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var timeLeft: Int = 5
    @Published var gameState: Int = 0
    @Published var isAlertShowing: Bool = false
    @Published var quizWordColor: Color = .gray
    @Published var quizWordText: String = "Gray"
    @Published var leftButtonColor: Color = .gray
    @Published var rightButtonColor: Color = .gray
    @Published var answerResultColour: Color = .init("background")
    @Published var navBarTitle: String = "Now Playing"
    
    var timer = Timer()
    var wrongAnswerTimer = Timer()
    let quizCheck = QuizCheck(rightAnswer: 0, wrongAnswer: 0, noWrongAnswer: false)
    let colourArray = ["Black", "White", "Red", "Blue", "Yellow", "Green", "Orange", "Purple", "Pink", "Indigo", "Teal", "Gray"]
    var isGamePaused = false
    //NSUserDefaults
    fileprivate let defaults = UserDefaults.standard
    
    fileprivate func fireTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleUpdateTimer), userInfo: nil, repeats: true)
    }
    
    fileprivate func fireWrongAnswerTimer() {
        wrongAnswerTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(handleWrongAnswerUI), userInfo: nil, repeats: false)
    }
    
    func setNavbarTitle(gameState: Int) {
        switch gameState {
        case 0:
            navBarTitle = "Game Over"
        case 1:
            navBarTitle = "Now Playing"
        case 2:
            navBarTitle = "Paused"
        default:
            navBarTitle = "Uh Oh"
        }
    }
    
    func startGame() {
        highScore = defaults.integer(forKey: "highScore")
        score = 0
        lives = 3
        timeLeft = 5
        gameState = 1
        setNavbarTitle(gameState: gameState)
        playGame()
    }
    
    fileprivate func playGame() {
        setQuizWord()
        fireTimer()
    }
    
    fileprivate func rightAnswer() {
        print("right answer")
        setTimeLeftValue()
        score += 1
        playGame()
    }
    
    fileprivate func wrongAnswer() {
        print("wrong answer")
        answerResultColour = .red
        if timer.isValid {
            timer.invalidate()
        }
        fireWrongAnswerTimer()
        lives -= 1
        //if there are still lives then play again or game over
        if lives > 0 {
            setTimeLeftValue()
            playGame()
        } else {
            gameOver()
        }
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
    
    fileprivate func gameOver() {
        print("game over")
        answerResultColour = .init("background")
        gameState = 0
        setNavbarTitle(gameState: gameState)
        if score > highScore {
            highScore = score
            defaults.set(score, forKey: "highScore")
        }
        isAlertShowing = true
    }
    
    func pauseGame() {
        print("Pause")
        print(gameState)
        isGamePaused.toggle()
        if isGamePaused {
            gameState = 2
            timer.invalidate()
        } else {
            gameState = 1
            fireTimer()
        }
        setNavbarTitle(gameState: gameState)
    }
    
    func endGame() {
        timer.invalidate()
        gameOver()
    }
    
    fileprivate func setQuizWord() {
        let colourOne = Int.random(in: 0..<colourArray.count)
        let colourTwo = Int.random(in: 0..<colourArray.count)
        let position =  Int.random(in: 0..<2)
        
        //set quizWord text colour off colour 1
        quizWordColor = setQuizColour(colourInt: colourOne)
        
        //set quizWord text off colour 2
        quizWordText = colourArray[colourTwo]
        
        //set which button gets which colour and thus which is the right and wrong answer
        if position == 0 {
            //right button correct
            leftButtonColor = setQuizColour(colourInt: colourOne)
            rightButtonColor = setQuizColour(colourInt: colourTwo)
            quizCheck.rightAnswer = 1
            quizCheck.wrongAnswer = 0
            quizCheck.noWrongAnswer = false
        } else {
            //left button correct
            leftButtonColor = setQuizColour(colourInt: colourTwo)
            rightButtonColor = setQuizColour(colourInt: colourOne)
            quizCheck.rightAnswer = 0
            quizCheck.wrongAnswer = 1
            quizCheck.noWrongAnswer = false
        }
        
        if colourOne == colourTwo {
            quizCheck.noWrongAnswer = true
        }
    }
    
    fileprivate func setQuizColour(colourInt: Int) -> Color {
        var colour: Color
        
        switch colourInt {
        case 0:
            colour = .black
        case 1:
            colour = .white
        case 2:
            colour = .red
        case 3:
            colour = .blue
        case 4:
            colour = .yellow
        case 5:
            colour = .green
        case 6:
            colour = .orange
        case 7:
            colour = .purple
        case 8:
            colour = .init(#colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1))
        case 9:
            colour = .init(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        case 10:
            colour = .init(red: 0, green: 253, blue: 255)
        case 11:
            colour = .gray
        default:
            colour = .gray
        }
        return colour
    }
    
    func handleTapButton(sender: Int) {
        
        //stop timer
        timer.invalidate()
        
        //reset time off vars and UI
        setTimeLeftValue()
        
        if sender == quizCheck.rightAnswer || quizCheck.noWrongAnswer {
            //if right increase score and play again
            rightAnswer()
        } else {
            //if wrong take away life
            wrongAnswer()
        }
    }
    @objc fileprivate func handleUpdateTimer() {
        print("handleUpdateTimer - \(timeLeft)")
        timeLeft -= 1
        if timeLeft == 0 {
            wrongAnswer()
        }
    }
    
    @objc fileprivate func handleWrongAnswerUI() {
        answerResultColour = .init("background")
    }
    
}
