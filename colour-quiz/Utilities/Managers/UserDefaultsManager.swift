//
//  UserDefaultsManager.swift
//  colour-quiz
//
//  Created by James Fitch on 3/8/2022.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
    @AppStorage("colourHighScore") var highScore: Int  = 0
    @AppStorage("iCloudEnabled") var iCloudEnabled: Bool = false
    @AppStorage("defaultDifficulty") var defaultDifficulty: GameDifficulty = .easy
    @AppStorage("similarColours") var similarColours: Bool = false
    
}
