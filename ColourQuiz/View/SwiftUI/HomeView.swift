//
//  ContentView.swift
//  ColourQuiz
//
//  Created by James Fitch on 22/10/19.
//  Copyright © 2019 Fitchatron. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var env: HomeEnvironment
    @ObservedObject var vm = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.init("background").edgesIgnoringSafeArea(.all)
                VStack {
                    Image("brain")
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                        .clipped()
                        .padding(.vertical, 24)
                    
                    NavigationLink(destination: HowToPlayView(), isActive: $env.isHowToShowing, label: {
                        HStack {
                            Spacer()
                            Text("How to Play")
                                .foregroundColor(.white)
                                .font(.system(size: 34))
                            Spacer()
                        }
                        .frame(height: 60)
                        .background(Color.blue)
                        .cornerRadius(4)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 24)
                    })
                    
                    NavigationLink(destination: QuizView(), isActive: $env.isQuizShowing, label: {
                        HStack {
                            Spacer()
                            Text("Play Now")
                                .foregroundColor(.white)
                                .font(.system(size: 34))
                            Spacer()
                        }
                        .frame(height: 60)
                        .background(Color.blue)
                        .cornerRadius(4)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 24)
                    })
                    
                    Text("High Score: \(vm.highScore)")
                        .font(.system(size: 24))
                        .padding(.bottom, 12)
                    
                    Button(action: {
                        self.vm.resetHighScore()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Play Now")
                                .foregroundColor(.white)
                                .font(.system(size: 24))
                            Spacer()
                        }
                        .frame(height: 40)
                        .background(Color.blue)
                        .cornerRadius(4)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 18)
                    })
                }
            }
            .navigationBarTitle(Text("Colour Brain Quiz"))
        }.onAppear {
            self.vm.setHighScore()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(HomeEnvironment())
            //.environment(\.colorScheme, .dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}

class HomeEnvironment: ObservableObject {
    @Published var isQuizShowing = false
    @Published var isHowToShowing = false
}
