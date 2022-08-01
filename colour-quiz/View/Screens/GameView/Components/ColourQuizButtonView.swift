//
//  ColourQuizButtonView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

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

struct ColourQuizButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ColourQuizButtonView(colour: .green)
    }
}
