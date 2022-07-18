//
//  HowToPlayView.swift
//  ColourQuiz
//
//  Created by James Fitch on 23/10/19.
//  Copyright © 2019 Fitchatron. All rights reserved.
//

import SwiftUI

struct HowToPlayView: View {
    
    @EnvironmentObject var env: HomeEnvironment
    
    var body: some View {
        ZStack {
            Color.init("background").edgesIgnoringSafeArea(.all)
            VStack {
                Group {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            QuizLabels(integer: 56, label: "High Score")
                            QuizLabels(integer: 8, label: "Score")
                            QuizLabels(integer: 3, label: "Lives")
                            Spacer()
                        }.padding(.horizontal, 6)
                        VStack(alignment: .leading) {
                            Text("Time Remaining: ")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                            HStack {
                                Text("4")
                                    .font(.system(size: 22))
                                Text(" seconds")
                                    .font(.system(size: 22))
                            }
                            Spacer()
                        }.padding(.horizontal, 6)
                    }.padding(.top, 24)
                }
                Text("White")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.bottom, 60)
                HStack(spacing: 12) {
                    QuizButtonView(sender: 0, gameState: 1, buttonColor: .white, vm: QuizViewModel()).disabled(true)
                    QuizButtonView(sender: 1, gameState: 1, buttonColor: .blue, vm: QuizViewModel()).disabled(true)
                }.padding(.bottom, 80).padding(.top, 40).padding(.horizontal, 6)
                HStack(spacing: 24) {
                    Button(action: {
                        print("End Game")
                    }, label: {
                        SettingsLabel(label: "End Game")
                    }).disabled(true)
                    Button(action: {
                        print("Pause Game")
                    }, label: {
                        SettingsLabel(label: "Pause Game").disabled(true)
                    })
                }.padding(.horizontal, 24).padding(.bottom, 24)
            }
            }.gesture(
                TapGesture().onEnded({ (_) in
                    print("tap tap")
                })
            )
            .navigationBarTitle(Text("How To Play"))
            .navigationBarItems(leading: Button(action: {
                self.env.isHowToShowing = false
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }))
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
