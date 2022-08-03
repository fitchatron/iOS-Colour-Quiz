//
//  GameView.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

struct GameView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var userDefaultsManager: UserDefaultsManager
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        ZStack {
            PlayingView(viewModel: viewModel)
            
        }
        .navigationTitle(viewModel.navTitle)
        .onAppear { viewModel.handleStartGame(difficulty: userDefaultsManager.defaultDifficulty, allowSimilarColours: userDefaultsManager.similarColours)}
        .sheet(isPresented: $viewModel.isShowingSheet, onDismiss: {
            if viewModel.game.gameState == .paused { viewModel.game.gameState = .playing }
        }) {
            PauseView(viewModel: viewModel)
        }
        
        .alert("Game Over", isPresented: $viewModel.isShowingAlert, actions: {
            Button("Play Again", role: .none) { viewModel.handleRestartGame(difficulty: userDefaultsManager.defaultDifficulty, allowSimilarColours: userDefaultsManager.similarColours) }
            Button("OK", role: .cancel) { }
        }, message: {
            Text("well done you got \(viewModel.game.score) right")
        })
        .onReceive(viewModel.timer) { time in viewModel.handleTimerChange(userDefaultsManager) }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.game.gameState = .playing
            } else {
                viewModel.game.gameState = .inactive
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameView()
        }
            .colorScheme(.dark)
    }
}
