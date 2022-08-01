//
//  GameViewModel.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

class GameViewModel: ObservableObject {
    //    @Published var score = 0
    //    @Published var highScore = 10
    //    @Published var lives = 3
    //    @Published var timeRemaining = 5
    //    @Published var gameState: GameState = .notStarted
    //    @Published var gameDifficulty: GameDifficulty = .easy
    //    @Published var quizQuestion: QuizQuestion = .init(colour: .gray, text: .gray, answer: .gray)
    @Published var game: Game = .init(score: 0, highScore: 10, lives: 3, timeRemaining: 5)
    @Published var firstColour: Color = .gray
    @Published var secondColour: Color = .gray
    @Published var isShowingSheet = false
    @Published var isShowingAlert = false
    @Published var progress: Double = 1
    //    @Published var isActive = true
    var navTitle: String {
        switch game.gameState {
        case .notStarted:
            return "Colour Quiz"
        case .playing:
            return "Now Playing"
        case .paused:
            return "Paused"
        case .gameOver:
            return "Game Over"
        default:
            return "Colour Quiz"
        }
    }
    
    var isButtonDisabled: Bool { game.gameState != .playing }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let colours: [Color] = [
        .blue,
        .brown,
        .cyan,
        .green,
        .indigo,
        .mint,
        .orange,
        .pink,
        .purple,
        .red,
        .teal,
        .yellow
    ]
    
    let exclusions:[Color: [Color]] = [
        .cyan: [.teal, .mint],
        .mint: [.teal, .cyan],
        .pink: [.red],
        .red: [.pink],
        .teal: [.cyan, .mint]
    ]
    
    //MARK: Start Game
    func handleStartGame() {
        generateQuizQuestion()
        game.gameState = .playing
        print(game.gameState, "game state is")
    }
    
    //MARK: Randomly Generate Colour
    func generateColourFrom(_ colours: [Color]) -> Color {
        let index = Int.random(in: 0..<colours.count)
        return colours[index]
    }
    
    // generate quiz question
    func generateQuizQuestion() {
        let colourOptions: [Color] = [generateColourFrom(colours), generateColourFrom(colours)]
        let colourIndex = Int.random(in: 0..<colourOptions.count)
        let textIndex = 1 - colourIndex
        
        firstColour = colourOptions[colourIndex]
        secondColour = colourOptions[textIndex]
        
        if !game.allowSimilarColours {
            var isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
            
            while isExcludedColour {
                secondColour = generateColourFrom(colours)
                isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
            }
        }
        game.quizQuestion = .init(colour: firstColour, text: secondColour, answer: secondColour)
    }
    
    //MARK: handle when button is tapped
    func handleButtonTapped(colour: Color) {
        
        guard game.gameState == .playing else { return }
        let isCorrectAnswer = handleCheckGuess(guess: colour, question: game.quizQuestion)
        
        if !isCorrectAnswer {
            handleIncorrectGuess()
            return
        }
        
        handleCorrectGuess()
        return
    }
    
    //MARK: Check Guess
    func handleCheckGuess(guess colour: Color, question: QuizQuestion) -> Bool {
        return colour == question.answer
    }
    
    //MARK: Handle Correct Guess
    func handleCorrectGuess() {
        game.score += 1
        handleCheckGameDifficulty()
        nextQuestion()
    }
    
    //MARK: Handle Incorrect Guess
    func handleIncorrectGuess() {
        do {
            try handleLoseLife()
            if  game.gameState == .playing {
                nextQuestion()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func nextQuestion() {
        game.timeRemaining = game.gameDifficulty.secondsPerGuess
        updateProgress()
        generateQuizQuestion()
    }
    
    //MARK: Increase Difficulty
    func handleCheckGameDifficulty() {
        if game.score > game.gameDifficulty.maxScore {
            game.gameDifficulty = game.gameDifficulty.nextDifficulty
        }
    }
    
    //MARK: Handle Pause Game
    func togglePauseGame() {
        guard game.gameState != .notStarted, game.gameState != .gameOver else { return }
        game.gameState = game.gameState == .paused ? .playing : .paused
        isShowingSheet = game.gameState == .paused ? true : false
        print("paused has run", game.gameState)
    }
    
    //MARK: Handle Game Over
    func handleGameOver() {
        print("💀 game over")
        // check for high score
        // send alert
        isShowingAlert = true
    }
    
    //MARK: Handle Restart Game
    func handleRestartGame() {
        game.lives = 3
        game.score = 0
        game.gameDifficulty = .easy
        game.timeRemaining = game.gameDifficulty.secondsPerGuess
        handleStartGame()
    }
    
    // process loss of life
    func handleLoseLife() throws {
        if game.lives <= 0 { throw ColourQuizError.runtimeError("No lives left to deduct") }
        
        game.lives -= 1
        
        if game.lives <= 0 {
            game.gameState = .gameOver
            handleGameOver()
        }
    }
    
    // logic on timer change
    func handleTimerChange() {
        guard game.gameState == .playing else { return }
        
        if game.timeRemaining <= 0 {
            handleIncorrectGuess()
            return
        }
        
        if game.timeRemaining > 0 {
            game.timeRemaining -= 1
            updateProgress()
            return
        }
    }
    
    // update progress var for timer
    func updateProgress() {
        progress = (Double(game.timeRemaining) / Double(game.gameDifficulty.secondsPerGuess) * 100).rounded() / 100
    }
}
