//
//  UIStackView-Game.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import UIKit

public extension UIStackView {
    public static func horizontalStackViewWithButtons(buttons: [UIButton]) -> UIStackView {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        
        for button in buttons {
            buttonsStackView.addArrangedSubview(button)
        }
        
        return buttonsStackView
    }
}
