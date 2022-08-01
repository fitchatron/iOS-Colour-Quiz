//
//  LivesCounterView.swift
//  colour-quiz
//
//  Created by James Fitch on 24/7/2022.
//

import SwiftUI

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

struct LivesCounterView_Previews: PreviewProvider {
    static var previews: some View {
        LivesCounterView(lives: 2)
    }
}
