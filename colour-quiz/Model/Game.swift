//
//  Game.swift
//  colour-quiz
//
//  Created by James Fitch on 1/8/2022.
//

import Foundation

class Game {
    var score: Int
    var highScore: Int
    var lives:Int
    var timeRemaining: Int
    var gameState: GameState = .notStarted
    var gameDifficulty: GameDifficulty = .easy
    var quizQuestion: QuizQuestion = .init(colour: .gray, text: .gray, answer: .gray)
    var allowSimilarColours = false
    
    init(score: Int, highScore: Int, lives: Int, timeRemaining: Int, gameState: GameState, gameDifficulty: GameDifficulty, quizQuestion: QuizQuestion) {
        self.score = score
        self.highScore = highScore
        self.lives = lives
        self.timeRemaining = timeRemaining
        self.gameState = gameState
        self.gameDifficulty = gameDifficulty
        self.quizQuestion = quizQuestion
    }
    
    init(score: Int, highScore: Int, lives: Int, timeRemaining: Int) {
        self.score = score
        self.highScore = highScore
        self.lives = lives
        self.timeRemaining = timeRemaining
    }
}
