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
    @Published var gameState = 0
    @Published var quizWordColour: Color = .green
    @Published var quizWordText: String = "Purple"
    @Published var firstButtonColour: Color = .purple
    @Published var secondButtonColour: Color = .green
    @Published var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}
