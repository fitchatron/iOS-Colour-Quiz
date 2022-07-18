//
//  QuizWord.swift
//  ColourQuiz
//
//  Created by James Fitch on 3/11/19.
//  Copyright © 2019 Fitchatron. All rights reserved.
//

import Foundation
import SwiftUI

class QuizWord {
    var title: String?
    var colour: Color?
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String
        self.colour = dictionary["colour"] as? Color
    }
}
