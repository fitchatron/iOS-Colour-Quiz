//
//  GameViewModel_Tests.swift
//  colour-quizTests
//
//  Created by James Fitch on 21/7/2022.
//

import XCTest
@testable import colour_quiz
import SwiftUI
/*
 Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehaviour
 Testing Structure: Given, When, Then
 
*/


final class GameViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GameViewModel_gameState_shouldBePlaying() {
        // given
        let startingGameState: GameState = .playing
        
        // when
        let vm = GameViewModel()
        vm.handleStartGame()
        
        // then
        XCTAssert(vm.game.gameState == startingGameState)
        XCTAssert(vm.game.quizQuestion.colour != .gray)
        XCTAssert(vm.game.quizQuestion.text != .gray)
        XCTAssert(vm.game.quizQuestion.answer != .gray)
    }
    
    func test_GameViewModel_lives_shouldLoseLifePass() {
        // given
        var expectedLives = 3
        
        // when
        let vm = GameViewModel()
        XCTAssertEqual(vm.game.lives, expectedLives, accuracy: .zero)
        XCTAssertNoThrow(try vm.handleLoseLife())
        
        // then
        expectedLives = 2
        XCTAssertEqual(vm.game.lives, expectedLives, accuracy: .zero)
    }
    
    func test_GameViewModel_lives_shouldLoseLifeError() {
        // given
        
        // when
        let vm = GameViewModel()
        
        // then
        XCTAssertNoThrow(try vm.handleLoseLife())
        XCTAssertNoThrow(try vm.handleLoseLife())
        XCTAssertNoThrow(try vm.handleLoseLife())
        XCTAssertThrowsError(try vm.handleLoseLife()) { error in
            XCTAssertEqual(error as! ColourQuizError, ColourQuizError.runtimeError("No lives left to deduct"))
        }
    }
    
    func test_GameViewModel_lives_CorrectGuess() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        
        // when
        let vm = GameViewModel()
        vm.game.gameState = .playing
        vm.game.quizQuestion = quizQuestion
        let score = vm.game.score
        let lives = vm.game.lives
        vm.handleButtonTapped(colour: .pink)
        print(score, vm.game.score)
        // then
        XCTAssertTrue(vm.game.score > score)
        XCTAssertTrue(vm.game.lives == lives)
    }
    
    func test_GameViewModel_gameState_IncorrectGuessWithExtraLives() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        
        // when
        let vm = GameViewModel()
        vm.game.gameState = .playing
        vm.game.quizQuestion = quizQuestion
        let score = vm.game.score
        let lives = vm.game.lives
        vm.handleButtonTapped(colour: .purple)
        
        // then
        XCTAssertTrue(vm.game.score == score)
        XCTAssertTrue(vm.game.lives < lives)
        XCTAssertTrue(vm.game.gameState == .playing)
    }
    
    func test_GameViewModel_gameState_IncorrectGuessWithoutExtraLives() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        
        // when
        let vm = GameViewModel()
        vm.game.gameState = .playing
        vm.game.quizQuestion = quizQuestion
        vm.game.lives = 1
        vm.handleButtonTapped(colour: .purple)
        
        // then
        XCTAssertTrue(vm.game.gameState == .gameOver)
    }
    
    func test_GameViewModel_gameState_PauseGame() {
        // given
        
        // when
        let vm = GameViewModel()
        vm.handleStartGame()
        
        vm.togglePauseGame()
        
        // then
        XCTAssertTrue(vm.game.gameState == .paused)
    }
    
    func test_GameViewModel_gameState_ResumeGame() {
        // given
        
        // when
        let vm = GameViewModel()
        vm.handleStartGame()
        
        vm.togglePauseGame()
        XCTAssertTrue(vm.game.gameState == .paused)
        vm.togglePauseGame()
        // then
        XCTAssertTrue(vm.game.gameState == .playing)
    }
    
    func test_GameViewModel_gameDifficulty_EasyToMedium() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        let startScore = 15
        // when
        let vm = GameViewModel()
        vm.game.quizQuestion = quizQuestion
        vm.game.gameState = .playing
        vm.game.score = startScore
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.game.gameDifficulty == .medium)
    }
    
    func test_GameViewModel_gameDifficulty_MediumToHard() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        let startScore = 40
        // when
        let vm = GameViewModel()
        vm.game.quizQuestion = quizQuestion
        vm.game.gameState = .playing
        vm.game.score = startScore
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.game.gameDifficulty == .medium)
    }
    
    func test_GameViewModel_gameDifficulty_HardToInsane() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        let startScore = 99
        // when
        let vm = GameViewModel()
        vm.game.quizQuestion = quizQuestion
        vm.game.gameState = .playing
        vm.game.score = startScore
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.game.gameDifficulty == .medium)
    }
    
    func test_GameViewModel_excludedColour_failCheck() {
        // given
        let exclusions:[Color: [Color]] = [
            .cyan: [.teal, .mint],
            .mint: [.teal, .cyan],
            .pink: [.red],
            .red: [.pink],
            .teal: [.cyan, .mint]
        ]
        
    
        // when
        
        
        let firstColour: Color = .cyan
        let secondColour: Color = .mint
        
        let isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
        // then
        XCTAssertTrue(isExcludedColour)
    }
    
    func test_GameViewModel_excludedColour_passCheck() {
        // given
        
        let exclusions:[Color: [Color]] = [
            .cyan: [.teal, .mint],
            .mint: [.teal, .cyan],
            .pink: [.red],
            .red: [.pink],
            .teal: [.cyan, .mint]
        ]
        
    
        // when
        
        
        let firstColour: Color = .cyan
        var secondColour: Color = .mint
        
        var isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
        
        while isExcludedColour {
            secondColour = .orange
            isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
        }
        
        // then
        XCTAssertFalse(isExcludedColour)
    }
    
    func test_GameViewModel_excludedColour_StressPassCheck() {
        // given
        let exclusions:[Color: [Color]] = [
            .cyan: [.teal, .mint],
            .mint: [.teal, .cyan],
            .pink: [.red],
            .red: [.pink],
            .teal: [.cyan, .mint]
        ]
        
        // when
        let vm = GameViewModel()
        XCTAssertFalse(vm.game.allowSimilarColours)
        for index in 0..<100 {
            vm.generateQuizQuestion()
            
            let firstColour: Color = vm.game.quizQuestion.colour
            let secondColour: Color = vm.game.quizQuestion.text
            
            let isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
            print(index, firstColour.stringify, secondColour.stringify, isExcludedColour)
            // then
            XCTAssertFalse(isExcludedColour)
        }
        
    }
    
    func test_GameViewModel_NoExludedColour_StressPassCheck() {
        // given
        let exclusions:[Color: [Color]] = [
            .cyan: [.teal, .mint],
            .mint: [.teal, .cyan],
            .pink: [.red],
            .red: [.pink],
            .teal: [.cyan, .mint]
        ]
        
        // when
        let vm = GameViewModel()
        vm.game.allowSimilarColours = true
        XCTAssertTrue(vm.game.allowSimilarColours)
        for index in 0..<100 {
            vm.generateQuizQuestion()
            
            let firstColour: Color = vm.game.quizQuestion.colour
            let secondColour: Color = vm.game.quizQuestion.text
            
            let isExcludedColour = exclusions[firstColour]?.first(where: {$0 == secondColour}) != nil
            if isExcludedColour { print(index, firstColour.stringify, secondColour.stringify, isExcludedColour) }
            // then
            XCTAssertTrue(isExcludedColour || !isExcludedColour)
        }
        
    }
    
    func test_GameViewModel_StressDifferentAnswers_LoseLife() {
        // given
        let vm = GameViewModel()
        
        // when
        vm.game.allowSimilarColours = true
        XCTAssertTrue(vm.game.allowSimilarColours)
        vm.handleStartGame()
        let lives = vm.game.lives
        
        for _ in 0..<20 {
            let answer = vm.secondColour
            vm.handleButtonTapped(colour: answer)
        }
        
        XCTAssertLessThan(vm.game.lives, lives)
    }
}
