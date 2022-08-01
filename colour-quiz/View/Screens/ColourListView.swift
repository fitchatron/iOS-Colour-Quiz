//
//  ColourListView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

struct ColourListView: View {
    let colours: [Color] = [
        .blue,
        .brown,
        .cyan, //teal mint
        .green,
        .indigo,
        .mint, //teal, cyan
        .orange,
        .pink, //red
        .purple,
        .red, //pink
        .teal, //cyan, mint
        .yellow
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Check out the colours below so you know what is what. Be casreful, some of the colours are deceptively similar.")
                .padding()
            
            List {
                ForEach(colours, id: \.self) { colour in
                    HStack {
                        ColourQuizButtonView(colour: colour)
                            .frame(width: 130)
                        
                        Text("\(colour.stringify.capitalized)")
                            .font(.title)
                            .foregroundColor(colour)
                            .bold()

                    }
                }
            }
            .navigationTitle("Colour List")
        }
    }
}

struct ColourListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ColourListView()
                .colorScheme(.dark)
        }
    }
}
