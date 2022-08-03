//
//  colour_quizApp.swift
//  colour-quiz
//
//  Created by James Fitch on 11/7/2022.
//

import SwiftUI

@main
struct colour_quizApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(UserDefaultsManager())
        }
    }
}
