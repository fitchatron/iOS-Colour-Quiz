//
//  RoundedQuizButton.swift
//  ColourQuiz
//
//  Created by James Fitch on 5/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import UIKit

class RoundedQuizButton: UIButton {
    
    init(colour: UIColor) {
        super.init(frame: .zero)
        let dimension: CGFloat = 150
        constrainHeight(dimension)
        constrainHeight(dimension)
        layer.cornerRadius = dimension / 2
        backgroundColor = colour
        layer.borderWidth = 3
        if traitCollection.userInterfaceStyle == .light {
            layer.borderColor = UIColor.black.cgColor
        } else {
            layer.borderColor = UIColor.white.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
