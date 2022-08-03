//
//  GameViewModel.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

extension GameView {
    class GameViewModel: ObservableObject {
        // MARK: Variables
       
        private let userDefaults = UserDefaults.standard
        
        @Published var game: Game = .init(timeRemaining: GameDifficulty.easy.secondsPerGuess)
        @Published var firstColour: Color = .gray
        @Published var secondColour: Color = .gray
        @Published var isShowingSheet = false
        @Published var isShowingAlert = false
        @Published var progress: Double = 1
        
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
        private let colours: [Color] = [
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
        
        private let exclusions:[Color: [Color]] = [
            .cyan: [.teal, .mint],
            .mint: [.teal, .cyan],
            .pink: [.red],
            .red: [.pink],
            .teal: [.cyan, .mint]
        ]
        
        // MARK: Game States
        // MARK: Start Game
        func handleStartGame(difficulty: GameDifficulty = .easy, allowSimilarColours: Bool) {
            game.allowSimilarColours = allowSimilarColours
            if difficulty != .easy {
                game.gameDifficulty = difficulty
                game.timeRemaining = difficulty.secondsPerGuess
            }
            
            generateQuizQuestion()
            game.gameState = .playing
            print("game state is", game.gameState)
        }
        
        // MARK: Pause Game
        func togglePauseGame() {
            guard game.gameState != .notStarted, game.gameState != .gameOver else { return }
            game.gameState = game.gameState == .paused ? .playing : .paused
            isShowingSheet = game.gameState == .paused ? true : false
            print("paused has run", game.gameState)
        }
        
        // MARK: Game Over
        func handleGameOver(_ userDefaultsManager: UserDefaultsManager) {
            print("💀 game over")
            
            // check for high score
            if game.score > userDefaultsManager.highScore {
                print("🏆")
                userDefaultsManager.highScore = game.score
            }
            // send alert
            isShowingAlert = true
        }
        
        // MARK: Restart Game
        func handleRestartGame(difficulty: GameDifficulty = .easy, allowSimilarColours: Bool) {
            game.lives = 3
            game.score = 0
            game.gameDifficulty = .easy
            game.timeRemaining = game.gameDifficulty.secondsPerGuess
            handleStartGame(allowSimilarColours: allowSimilarColours)
        }
        
        // MARK: Set Questions
        // Randomly Generate Colour
        func generateColourFrom(_ colours: [Color]) -> Color {
            let index = Int.random(in: 0..<colours.count)
            return colours[index]
        }
        
        // generate quiz question
        func generateQuizQuestion() {
            var colourOptions: [Color] = [generateColourFrom(colours), generateColourFrom(colours)]
            let colourIndex = Int.random(in: 0..<colourOptions.count)
            let textIndex = 1 - colourIndex
            
            firstColour = colourOptions[colourIndex]
            secondColour = colourOptions[textIndex]
            
            if !game.allowSimilarColours {
                var isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
                
                while isExcludedColour {
                    colourOptions[textIndex] = generateColourFrom(colours)
                    secondColour = colourOptions[textIndex]
                    isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
                }
            }
            game.quizQuestion = .init(colour: colourOptions.first!, text: colourOptions.last!, answer: colourOptions.last!)
        }
        
        //MARK: handle when button is tapped
        func handleButtonTapped(colour: Color, _ userDefaultsManager: UserDefaultsManager) {
            
            guard game.gameState == .playing else { return }
            let isCorrectAnswer = handleCheckGuess(guess: colour, question: game.quizQuestion)
            
            if !isCorrectAnswer {
                handleIncorrectGuess(userDefaultsManager)
                return
            }
            
            handleCorrectGuess()
            return
        }
        
        // MARK: Check Guess
        func handleCheckGuess(guess colour: Color, question: QuizQuestion) -> Bool {
            return colour == question.answer
        }
        
        // MARK: Handle Correct Guess
        func handleCorrectGuess() {
            game.score += 1
            handleCheckGameDifficulty()
            nextQuestion()
        }
        
        // MARK: Handle Incorrect Guess
        func handleIncorrectGuess(_ userDefaultsManager: UserDefaultsManager) {
            do {
                try handleLoseLife(userDefaultsManager)
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
        
        // process loss of life
        func handleLoseLife(_ userDefaultsManager: UserDefaultsManager) throws {
            if game.lives <= 0 { throw ColourQuizError.runtimeError("No lives left to deduct") }
            
            game.lives -= 1
            
            if game.lives <= 0 {
                game.gameState = .gameOver
                handleGameOver(userDefaultsManager)
            }
        }
        
        // MARK: Change Difficulty
        func handleCheckGameDifficulty() {
            if game.score > game.gameDifficulty.maxScore {
                game.gameDifficulty = game.gameDifficulty.nextDifficulty
            }
        }
        
        // MARK: timer change
        // logic on timer change
        func handleTimerChange(_ userDefaultsManager: UserDefaultsManager) {
            guard game.gameState == .playing else { return }
            
            if game.timeRemaining <= 0 {
                handleIncorrectGuess(userDefaultsManager)
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

}
