//
//  QuizCheck.swift
//  ColourQuiz
//
//  Created by James Fitch on 5/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import UIKit

class QuizCheck {
    var rightAnswer: Int
    var wrongAnswer: Int
    var noWrongAnswer: Bool
    
    init(rightAnswer: Int, wrongAnswer: Int, noWrongAnswer: Bool) {
        self.rightAnswer = rightAnswer
        self.wrongAnswer = wrongAnswer
        self.noWrongAnswer = noWrongAnswer
    }
    
}
