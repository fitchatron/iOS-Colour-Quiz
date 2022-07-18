//
//  PauseView.swift
//  ColourQuiz
//
//  Created by James Fitch on 7/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import UIKit
import SwiftUI
import LBTATools

class PauseView: UIView {
    
    let label = UILabel(text: "Would you like to continue?", font: .boldSystemFont(ofSize: 32), textColor: .black, numberOfLines: 0)
    
    let pauseButton: OptionButton = {
        let button = OptionButton(titleText: "Pause")
        return button
    }()
    
    let endGameButton: OptionButton = {
        let button = OptionButton(titleText: "End Game")
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        stack(label, hstack(endGameButton, pauseButton, spacing: 36, distribution: .fillEqually), spacing: 42).padTop(12).padBottom(60).padRight(32).padLeft(32)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct PauseViewPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        //.environment(\.colorScheme, .dark)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
    
    struct ContainerView: UIViewRepresentable {
        typealias UIViewType = PauseView
        
        func makeUIView(context: UIViewRepresentableContext<PauseViewPreview.ContainerView>) -> PauseView {
            return PauseView()
        }
        
        func updateUIView(_ uiView: PauseView, context: UIViewRepresentableContext<PauseViewPreview.ContainerView>) {
        }
    }
}
