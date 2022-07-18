//
//  ContentView.swift
//  colour-quiz
//
//  Created by James Fitch on 11/7/2022.
//

import SwiftUI

struct ContentView: View {
    var score = 1
    var highScore = 10
    var lives = 3
    var colourText = "Purple"
    var colouring: Color = .green
    
    var body: some View {
        NavigationStack {
            
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
            }
            .padding()
            
            Spacer()
            Text("\(colourText)")
                .font(.system(size: 42))
                .bold()
                .foregroundColor(colouring)
            
            Spacer()
            HStack {
                Circle()
                    .overlay(
                        Circle()
                            .stroke(Color(.label), lineWidth: 6)
                    )
                    .padding()
                    .foregroundColor(.blue)
                
                Circle()
                    .overlay(
                        Circle()
                            .stroke(Color(.label), lineWidth: 6)
                    )
                    .padding()
                    .foregroundColor(.green)
            }
            .padding(.bottom)
            
            .navigationTitle("Colour Quiz")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
    }
}
