//
//  InfoView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI
extension GameView {
    struct InfoView: View {
        @ObservedObject var viewModel: GameViewModel
        @EnvironmentObject var userDefaultsManager: UserDefaultsManager
        
        var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Score: \(viewModel.game.score)")
                            .font(.system(size: 26))
                            .bold()
                    }
                    
                    HStack {
                        Text("High Score: \(userDefaultsManager.highScore)")
                            .font(.system(size: 18))
                            .bold()
                    }
                    
                    HStack {
                        if viewModel.game.gameState == .gameOver {
                            Button {
                                viewModel.handleRestartGame(difficulty: userDefaultsManager.defaultDifficulty, allowSimilarColours: userDefaultsManager.similarColours)
                            } label: {
                                Label("Play Again", systemImage: "restart.circle.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Button {
                                viewModel.togglePauseGame()
                            } label: {
                                Label("Pause", systemImage: "pause.circle.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("Time Left:")
                        .font(.system(size: 18))
                        .bold()
                    
                    ZStack {
                        //MARK: planceholder ring
                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(.gray)
                            .opacity(0.1)
                        
                        //MARK: coloured ring [.blue, .pink, .indigo, .purple, .cyan, .mint, .blue]
                        Circle()
                            .trim(from: 0.0, to: min(1, viewModel.progress))
                            .stroke(AngularGradient(colors: [.red, .orange, .yellow, .blue, .green], center: .center), style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                            .rotationEffect(Angle(degrees: 270))
                            .animation(.easeInOut(duration: 0.5), value: viewModel.progress)
                        
                        Text("\(viewModel.game.timeRemaining)")
                            .font(.headline)
                    }
                    .frame(width: 100)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
}

//struct InfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        InfoView(viewModel: GameViewModel())
//    }
//}
