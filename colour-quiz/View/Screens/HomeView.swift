//
//  HomeView.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("How to Play") {
                    HowToPlayView()
                }
                NavigationLink("New Game") {
                    GameView()
                }
                NavigationLink("Colour List") {
                    ColourListView()
                }
                NavigationLink("Settings") {
                    SettingsView()
                }
                
            }
            .navigationTitle("Colour Quiz")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
