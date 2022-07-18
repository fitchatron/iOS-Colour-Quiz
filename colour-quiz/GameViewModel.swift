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
    @Published var isActive = true
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
    
    //TODO: Generate Colour 1
    
    //TODO: Generate Colour 2
    
    //TODO: Check Guess
    
    //TODO: Handle Correct Guess
    
    //TODO: Handle Incorrect Guess
    
    //TODO: Increase Difficulty
    
    //TODO: Handle Pause Game
    
    //TODO: Handle Resume Game
    
    //TODO: Handle Game Over
    
    //TODO: Handle Restart Game
    
    func generateQuizQuestion() {
        let colourOneIndex = Int.random(in: 0..<colours.count)
        let colourTwoIndex = Int.random(in: 0..<colours.count)
        
        firstColour = colours[colourOneIndex]
        secondColour = colours[colourTwoIndex]
        
        quizQuestion = .init(colour: firstColour, text: secondColour, answer: secondColour)
    }
    
    func handleLoseLife() {
        lives -= 1
        
        if lives <= 0 {
            gameState = .gameOver
            print("💀 game over")
        }
    }
    
    func handleTimerChange() {
        guard isActive, gameState == .playing else { return }
        
        if timeRemaining <= 0 {
            handleLoseLife()
            if gameState == .playing {
                timeRemaining = secondsAllocated
                generateQuizQuestion()
            }
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
    case notStarted, playing, paused, gameOver
}

enum GameDifficulty: Int {
    case easy, medium, hard
    
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
        }
    }
}
