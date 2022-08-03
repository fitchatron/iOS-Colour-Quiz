//
//  PlayingView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

extension GameView {
    struct PlayingView: View {
        @EnvironmentObject var userDefaultsManager: UserDefaultsManager
        @ObservedObject var viewModel: GameViewModel
        
        var body: some View {
            VStack {
                InfoView(viewModel: viewModel)
                
                Spacer()
                QuestionView(quizQuestion: viewModel.game.quizQuestion)
                
                Spacer()
                HStack {
                    Button {
                        viewModel.handleButtonTapped(colour: viewModel.firstColour, userDefaultsManager)
                    } label: {
                        ColourQuizButtonView(colour: viewModel.firstColour)
                    }
                    .disabled(viewModel.isButtonDisabled)
                    .tag(1)
                    
                    Button {
                        viewModel.handleButtonTapped(colour: viewModel.secondColour, userDefaultsManager)
                    } label: {
                        ColourQuizButtonView(colour: viewModel.secondColour)
                    }
                    .disabled(viewModel.isButtonDisabled)
                    .tag(2)
                }
                .padding(.bottom)
                
                LivesCounterView(lives: viewModel.game.lives)
            }
        }
    }
}

//struct PlayingView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayingView(viewModel: GameViewModel())
//    }
//}
