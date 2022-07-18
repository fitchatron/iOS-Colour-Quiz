//
//  QuizView.swift
//  ColourQuiz
//
//  Created by James Fitch on 3/11/19.
//  Copyright © 2019 Fitchatron. All rights reserved.
//

import SwiftUI

struct QuizView: View {
    
    @EnvironmentObject var env: HomeEnvironment
    @ObservedObject var vm = QuizViewModel()
    var answer: Int?
    
    var body: some View {
        ZStack {
            Color.init("background").edgesIgnoringSafeArea(.all)
            VStack {
                Group {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            QuizLabels(integer: vm.highScore, label: "High Score")
                            QuizLabels(integer: vm.score, label: "Score")
                            QuizLabels(integer: vm.lives, label: "Lives")
                            Spacer()
                        }.padding(.horizontal, 6)
                        VStack(alignment: .leading) {
                            Text("Time Remaining: ")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                            HStack {
                                Text("\(vm.timeLeft)")
                                    .font(.system(size: 22))
                                Text(" seconds")
                                    .font(.system(size: 22))
                            }
                            Spacer()
                        }.padding(.horizontal, 6)
                    }.padding(.top, 24)
                }
                if vm.gameState == 0 {
                    Text(vm.navBarTitle)
                        .lineLimit(2)
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.bottom, 60)
                } else if vm.gameState == 1 {
                    Text(vm.quizWordText)
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(vm.gameState == 1 ? vm.quizWordColor : .gray)
                        .padding(.bottom, 60)
                } else {
                    Text(vm.navBarTitle)
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(.bottom, 60)
                }
                HStack(spacing: 12) {
                    QuizButtonView(sender: 0, gameState: vm.gameState, buttonColor: vm.leftButtonColor, vm: vm)
                    QuizButtonView(sender: 1, gameState: vm.gameState, buttonColor: vm.rightButtonColor, vm: vm)
                }.padding(.bottom, 80).padding(.top, 40).padding(.horizontal, 6)
                HStack(spacing: 24) {
                    Button(action: {
                        switch self.vm.gameState {
                        case 0: //game over
                            self.vm.startGame()
                        case 1: //now playing
                            self.vm.endGame()
                        case 2: //paused
                            self.vm.endGame()
                        default:
                            self.vm.endGame()
                        }
                    }, label: {
                        if vm.gameState == 0 {
                            SettingsLabel(label: "Play Again")
                        } else {
                            SettingsLabel(label: "End Game")
                        }
                    })
                    Button(action: {
                        self.vm.pauseGame()
                    }, label: {
                        SettingsLabel(label: vm.gameState == 2 ? "Resume Game" : "Pause Game")
                            .disabled(vm.gameState == 0 ? true : false)
                    })
                }.padding(.horizontal, 24).padding(.bottom, 24)
            }
        }.onAppear(perform: {
            self.vm.startGame()
        })
            .onDisappear(perform: {
                self.vm.endGame()
            })
            .navigationBarTitle(Text(vm.navBarTitle))
            .navigationBarItems(leading: Button(action: {
                self.env.isQuizShowing = false
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }))
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
        //.environment(\.colorScheme, .dark)
        //.previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}

struct QuizButtonView: View {
    
    var sender = Int()
    var gameState = Int()
    var buttonColor: Color?
    var vm = QuizViewModel()
    
    var body: some View {
        Button(action: {
            self.vm.handleTapButton(sender: self.sender)
        }, label: {
            Text("")
                .frame(width: 175, height: 175, alignment: .center)
        })
            .padding(.leading, 4)
            .disabled(gameState == 1 ? false : true)
            .background(gameState == 1 ? buttonColor : .gray)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 4))
    }
}

struct QuizLabels: View {
    
    var integer = Int()
    var label = String()
    
    var body: some View {
        HStack {
            Text("\(label): ")
                .font(.system(size: 22))
                .fontWeight(.semibold)
            Text("\(integer)")
                .font(.system(size: 22))
        }
    }
}

struct SettingsLabel: View {
    
    var label = String()
    
    var body: some View {
        Text(label)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 60)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(4)
    }
}
