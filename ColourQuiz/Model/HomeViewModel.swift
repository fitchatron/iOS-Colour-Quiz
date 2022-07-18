//
//  HomeViewModel.swift
//  ColourQuiz
//
//  Created by James Fitch on 19/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    //NSUserDefaults
    fileprivate let defaults = UserDefaults.standard
    
    @Published var highScore: Int = 0
    
    func setHighScore() {
        highScore = defaults.integer(forKey: "highScore")
    }
    
    func resetHighScore() {
        defaults.set(0, forKey: "highScore")
        highScore = 0
    }
}
