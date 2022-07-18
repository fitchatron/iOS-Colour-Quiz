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
            
            VStack {
                HStack {
                    Text("Score: \(viewModel.score)")
                        .font(.system(size: 26))
                        .bold()
                    
                    Spacer()
                }
                
                
                HStack {
                    Text("High Score: \(viewModel.highScore)")
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer()
                }
                
                HStack {
                    Text("Time Left: \(viewModel.time)")
                        .font(.system(size: 18))
                        .bold()
                    
                    Spacer()
                }
            }
            .padding()
            
            Spacer()
            Text("\(viewModel.quizOption.text.stringify.capitalized)")
                .font(.system(size: 42))
                .bold()
                .foregroundColor(viewModel.quizOption.colour)
            
            Spacer()
            HStack {
                Button {
                    print(viewModel.firstColour.stringify)
                } label: {
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(Color(.label), lineWidth: 6)
                        )
                        .padding()
                        .foregroundColor(viewModel.firstColour)
                }
                
                Button {
                    print(viewModel.secondColour.stringify)
                } label: {
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(Color(.label), lineWidth: 6)
                        )
                        .padding()
                        .foregroundColor(viewModel.secondColour)
                }
                
            }
            .padding(.bottom)
            
            HStack {
                ForEach(1..<4, content: { num in
                    Rectangle()
                        .foregroundColor(.pink)
                        .frame(height: 12)
                        .opacity(num > viewModel.lives ? 0.2 : 1)
                })
            }
            
            .navigationTitle("Colour Quiz")
            .onReceive(viewModel.timer) { time in
                
                guard viewModel.isActive else { return }
                
                if viewModel.time > 0 {
                    viewModel.time -= 1
                }
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.isActive = true
                } else {
                    viewModel.isActive = false
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .colorScheme(.dark)
    }
}
