//
//  GameViewModel.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var score = 1
    @Published var highScore = 10
    @Published var lives = 3
    @Published var time = 5
    @Published var gameState: GameState = .notStarted
    @Published var quizOption: QuizOption = .init(colour: .gray, text: .gray, answer: .gray)
    @Published var firstColour: Color = .gray
    @Published var secondColour: Color = .gray
    @Published var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
}


struct QuizOption {
    var colour: Color
    var text: Color
    var answer: Color
}

enum GameState: Int {
    case notStarted, playing, paused, gameOver
}
