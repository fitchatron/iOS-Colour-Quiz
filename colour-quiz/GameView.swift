//
//  GameView.swift
//  colour-quiz
//
//  Created by James Fitch on 18/7/2022.
//

import SwiftUI

struct GameView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                PlayingView(viewModel: viewModel)
                
            }
            .navigationTitle(viewModel.navTitle)
            .onAppear { viewModel.handleStartGame()}
            .sheet(isPresented: $viewModel.isShowingSheet, onDismiss: {
                if viewModel.gameState == .paused { viewModel.gameState = .playing }
            }) {
                PauseView(viewModel: viewModel)
            }
//            .alert("Game Over", isPresented: $viewModel.isShowingAlert) {
//                Button("OK", role: .cancel) { }
//                Button("Play Again", role: .cancel) { }
//            }
    
            .alert("Game Over", isPresented: $viewModel.isShowingAlert, actions: {
                Button("Play Again", role: .none) { viewModel.handleRestartGame() }
                Button("OK", role: .cancel) { }
            }, message: {
                Text("well done you got \(viewModel.score) right")
            })
            .onReceive(viewModel.timer) { time in viewModel.handleTimerChange() }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.gameState = .playing
                } else {
                    viewModel.gameState = .inactive
                }
            }
        }
    }
}

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
            
            InfoView(score: viewModel.score, highScore: viewModel.highScore, timeRemaining: viewModel.timeRemaining)
            
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
struct PlayingView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            InfoView(score: viewModel.score, highScore: viewModel.highScore, timeRemaining: viewModel.timeRemaining)
            
            HStack {
                Button {
                    viewModel.togglePauseGame()
                } label: {
                    Label("Pause", systemImage: "pause.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer()
            QuestionView(quizQuestion: viewModel.quizQuestion)
            
            Spacer()
            HStack {
                Button {
                    viewModel.handleButtonTapped(colour: viewModel.firstColour)
                } label: {
                    ColourQuizButtonView(colour: viewModel.firstColour)
                }
                .disabled(viewModel.isButtonDisabled)
                .tag(1)
                
                Button {
                    viewModel.handleButtonTapped(colour: viewModel.secondColour)
                } label: {
                    ColourQuizButtonView(colour: viewModel.secondColour)
                }
                .disabled(viewModel.isButtonDisabled)
                .tag(2)
            }
            .padding(.bottom)
            
            LivesCounterView(lives: viewModel.lives)
        }
    }
}

struct InfoView: View {
    let score: Int
    let highScore: Int
    let timeRemaining: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score)")
                    .font(.system(size: 26))
                    .bold()
                
                Spacer()
            }
            
            HStack {
                Text("High Score: \(highScore)")
                    .font(.system(size: 18))
                    .bold()
                
                Spacer()
            }
            
            HStack {
                Text("Time Left: \(timeRemaining)")
                    .font(.system(size: 18))
                    .bold()
                
                Spacer()
            }
        }
        .padding()
    }
}

struct QuestionView: View {
    let quizQuestion: QuizQuestion
    
    var body: some View {
        Text("\(quizQuestion.text.stringify.capitalized)")
            .font(.system(size: 42))
            .bold()
            .foregroundColor(quizQuestion.colour)
    }
}


struct ColourQuizButtonView: View {
    let colour: Color
    
    var body: some View {
        Circle()
            .overlay(
                Circle()
                    .stroke(Color(.label), lineWidth: 6)
            )
            .padding()
            .foregroundColor(colour)
    }
}

struct LivesCounterView: View {
    let lives: Int
    
    var body: some View {
        HStack {
            ForEach(1..<4, content: { num in
                Rectangle()
                    .foregroundColor(.pink)
                    .frame(height: 12)
                    .opacity(num > lives ? 0.2 : 1)
            })
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .colorScheme(.dark)
    }
}
