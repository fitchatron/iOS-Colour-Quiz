//
//  GameDifficulty.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import Foundation

enum GameDifficulty: Int, CaseIterable,Identifiable {
    case easy, medium, hard, insane
    
    var id: GameDifficulty {self}
    
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
