//
//  UIButton-Game.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import UIKit

// MARK: - Extension that defines a gamebutton
public extension UIButton {
    
    /// Function that creates a gamebutton
    ///
    /// - Parameter text: The text to put in the button
    /// - Returns: a completed button
    static func gameButtonWithText(text: String) -> UIButton {
        let gameButton = UIButton(frame: .zero)
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        gameButton.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
        gameButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        gameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        gameButton.setTitle(text, for: .normal)
        gameButton.setTitleColor(.black, for: .normal)
        gameButton.setTitleColor(.white, for: .highlighted)
        //Making Button Circular
        gameButton.layer.shadowColor = UIColor.black.cgColor
        gameButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        gameButton.layer.masksToBounds = false
        gameButton.layer.shadowRadius = 2.0
        gameButton.layer.shadowOpacity = 0.5
        gameButton.layer.cornerRadius = 20
        gameButton.layer.borderColor = UIColor.black.cgColor
        gameButton.layer.borderWidth = 2.0
        return gameButton
    }
}
