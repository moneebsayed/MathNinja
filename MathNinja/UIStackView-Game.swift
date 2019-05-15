//
//  UIStackView-Game.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import UIKit

// MARK: - Extension that defines a buttons stack view that creates the keypads
public extension UIStackView {
    
    /// Initializer for a row of the keypad for the app
    ///
    /// - Parameter buttons: the buttons to initialize the keypad with
    /// - Returns: a row of the keypad within a stackView
    static func horizontalStackViewWithButtons(buttons: [UIButton]) -> UIStackView {
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
