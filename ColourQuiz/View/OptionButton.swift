//
//  OptionButton.swift
//  ColourQuiz
//
//  Created by James Fitch on 5/1/20.
//  Copyright © 2020 Fitchatron. All rights reserved.
//

import UIKit

class OptionButton: UIButton {
    
    init(titleText: String) {
        super.init(frame: .zero)
        setTitle(titleText, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemBlue
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
