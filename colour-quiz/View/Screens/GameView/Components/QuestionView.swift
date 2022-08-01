//
//  QuestionView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

struct QuestionView: View {
    let quizQuestion: QuizQuestion
    
    var body: some View {
        Text("\(quizQuestion.text.stringify.capitalized)")
            .font(.system(size: 42))
            .bold()
            .foregroundColor(quizQuestion.colour)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(quizQuestion: .init(colour: .red, text: .blue, answer: .blue))
    }
}
