//
//  GameViewModel.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var score = 0
    @Published var highScore = 10
    @Published var lives = 3
    @Published var timeRemaining = 5
    @Published var gameState: GameState = .playing
    @Published var gameDifficulty: GameDifficulty = .easy
    private var secondsAllocated: Int { gameDifficulty.secondsPerGuess }
    @Published var quizQuestion: QuizQuestion = .init(colour: .gray, text: .gray, answer: .gray)
    @Published var firstColour: Color = .gray
    @Published var secondColour: Color = .gray
//    @Published var isActive = true
    var navTitle: String {
        switch gameState {
            
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
    
    var isButtonDisabled: Bool { gameState != .playing }
    
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
    
    //TODO: Start Game
    func handleStartGame() {
        generateQuizQuestion()
        gameState = .playing
    }
    
    //TODO: Randomly Generate Colour
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
        quizQuestion = .init(colour: colourOptions.first!, text: colourOptions.last!, answer: colourOptions.last!)
    }
    
    //TODO: handle when button is tapped
    func handleButtonTapped(colour: Color) {
        
        guard gameState == .playing else { return }
        let isCorrectAnswer = handleCheckGuess(guess: colour, question: quizQuestion)
        
        if !isCorrectAnswer {
            handleIncorrectGuess()
            return
        }
        
        handleCorrectGuess()
        return
    }
    
    //TODO: Check Guess
    func handleCheckGuess(guess colour: Color, question: QuizQuestion) -> Bool {
        return colour == question.answer
    }
    
    //TODO: Handle Correct Guess
    func handleCorrectGuess() {
        score += 1
        handleCheckGameDifficulty()
        nextQuestion()
    }
    
    //TODO: Handle Incorrect Guess
    func handleIncorrectGuess() {
        do {
            try handleLoseLife()
            if  gameState == .playing {
                nextQuestion()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func nextQuestion() {
        timeRemaining = secondsAllocated
        generateQuizQuestion()
    }
    
    //TODO: Increase Difficulty
    func handleCheckGameDifficulty() {
        if score > gameDifficulty.maxScore {
            gameDifficulty = gameDifficulty.nextDifficulty
        }
    }
    
    //TODO: Handle Pause Game
    func togglePauseGame() {
        guard gameState != .notStarted, gameState != .gameOver else { return }
        gameState = gameState == .paused ? .playing : .paused
    }
    
    //TODO: Handle Resume Game
    func handleResumeGame() {}
    
    //TODO: Handle Game Over
    func handleGameOver() {
        print("💀 game over")
        // check for high score
        // send alert
    }
    
    //TODO: Handle Restart Game
    func handleRestartGame() {
        lives = 3
        score = 0
        handleStartGame()
    }
    
    // process loss of life
    func handleLoseLife() throws {
        if lives <= 0 { throw ColourQuizError.runtimeError("No lives left to deduct") }
        
        lives -= 1
        
        if lives <= 0 {
            gameState = .gameOver
            handleGameOver()
        }
    }
    
    // logic on timer change
    func handleTimerChange() {
        guard gameState == .playing else { return }
        
        if timeRemaining <= 0 {
            handleIncorrectGuess()
//            do {
//                try handleLoseLife()
//            } catch {
//                print(error.localizedDescription)
//            }
//            if gameState == .playing {
//                timeRemaining = secondsAllocated
//                generateQuizQuestion()
//            }
            return
        }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
            return
        }
    }
}


struct QuizQuestion {
    var colour: Color
    var text: Color
    var answer: Color
}

enum GameState: Int {
    case notStarted, playing, paused, gameOver, inactive
}

enum GameDifficulty: Int {
    case easy, medium, hard, insane
    
    var name: String {
        return "\(self)".map {
            $0.isUppercase ? " \($0)" : "\($0)" }.joined().capitalized
    }
    
    var secondsPerGuess: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 3
        case .hard:
            return 2
        case .insane:
            return 1
        }
    }
    
    var maxScore: Int {
        switch self {
        case .easy:
            return 15
        case .medium:
            return 40
        case .hard:
            return 99
        case .insane:
            return 9999
        }
    }
    
    var nextDifficulty: GameDifficulty {
        switch self {
        case .easy:
            return .medium
        case .medium:
            return .hard
        case .hard:
            return .insane
        case .insane:
            return .insane
        }
    }
}

enum ColourQuizError: Error, Equatable {
    case runtimeError(String)
}
