//
//  PauseView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

extension GameView {
    struct PauseView: View {
        @ObservedObject var viewModel: GameViewModel
        
        var body: some View {
            Color(.systemBackground)
                .opacity(0.9)
                .edgesIgnoringSafeArea(.horizontal)
                .edgesIgnoringSafeArea(.top)
            
            VStack {
                Text("Paused")
                    .font(.largeTitle)
                    .bold()
                
                InfoView(viewModel: viewModel)
                
                Text("Game paused. Take your time to do you.")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    viewModel.togglePauseGame()
                } label: {
                    Label("Resume", systemImage: "play.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }
}

//struct PauseView_Previews: PreviewProvider {
//    static var previews: some View {
//        PauseView(viewModel: GameViewModel())
//    }
//}
