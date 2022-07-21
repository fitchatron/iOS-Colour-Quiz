//
//  GameViewModel_Tests.swift
//  colour-quizTests
//
//  Created by James Fitch on 21/7/2022.
//

import XCTest
@testable import colour_quiz
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
        XCTAssert(vm.gameState == startingGameState)
        XCTAssert(vm.quizQuestion.colour != .gray)
        XCTAssert(vm.quizQuestion.text != .gray)
        XCTAssert(vm.quizQuestion.answer != .gray)
    }
    
    func test_GameViewModel_lives_shouldLoseLifePass() {
        // given
        var expectedLives = 3
        
        // when
        let vm = GameViewModel()
        XCTAssertEqual(vm.lives, expectedLives, accuracy: .zero)
        XCTAssertNoThrow(try vm.handleLoseLife())
        
        // then
        expectedLives = 2
        XCTAssertEqual(vm.lives, expectedLives, accuracy: .zero)
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
        vm.quizQuestion = quizQuestion
        let score = vm.score
        let lives = vm.lives
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.score > score)
        XCTAssertTrue(vm.lives == lives)
    }
    
    func test_GameViewModel_gameState_IncorrectGuessWithExtraLives() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        
        // when
        let vm = GameViewModel()
        vm.quizQuestion = quizQuestion
        let score = vm.score
        let lives = vm.lives
        vm.handleButtonTapped(colour: .purple)
        
        // then
        XCTAssertTrue(vm.score == score)
        XCTAssertTrue(vm.lives < lives)
        XCTAssertTrue(vm.gameState == .playing)
    }
    
    func test_GameViewModel_gameState_IncorrectGuessWithoutExtraLives() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        
        // when
        let vm = GameViewModel()
        vm.quizQuestion = quizQuestion
        vm.lives = 1
        vm.handleButtonTapped(colour: .purple)
        
        // then
        XCTAssertTrue(vm.gameState == .gameOver)
    }
    
    func test_GameViewModel_gameState_PauseGame() {
        // given
        
        // when
        let vm = GameViewModel()
        vm.handleStartGame()
        
        vm.togglePauseGame()
        
        // then
        XCTAssertTrue(vm.gameState == .paused)
    }
    
    func test_GameViewModel_gameState_ResumeGame() {
        // given
        
        // when
        let vm = GameViewModel()
        vm.handleStartGame()
        
        vm.togglePauseGame()
        XCTAssertTrue(vm.gameState == .paused)
        vm.togglePauseGame()
        // then
        XCTAssertTrue(vm.gameState == .playing)
    }
    
    func test_GameViewModel_gameDifficulty_EasyToMedium() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        let startScore = 15
        // when
        let vm = GameViewModel()
        vm.quizQuestion = quizQuestion
        vm.gameState = .playing
        vm.score = startScore
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.gameDifficulty == .medium)
    }
    
    func test_GameViewModel_gameDifficulty_MediumToHard() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        let startScore = 40
        // when
        let vm = GameViewModel()
        vm.quizQuestion = quizQuestion
        vm.gameState = .playing
        vm.score = startScore
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.gameDifficulty == .medium)
    }
    
    func test_GameViewModel_gameDifficulty_HardToInsane() {
        // given
        let quizQuestion: QuizQuestion = .init(colour: .purple, text: .pink, answer: .pink)
        let startScore = 99
        // when
        let vm = GameViewModel()
        vm.quizQuestion = quizQuestion
        vm.gameState = .playing
        vm.score = startScore
        vm.handleButtonTapped(colour: .pink)
        
        // then
        XCTAssertTrue(vm.gameDifficulty == .medium)
    }
}
