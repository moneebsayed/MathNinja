//
//  UIButton-Game.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import UIKit

public extension UIButton {
    public static func gameButtonWithText(text: String) -> UIButton {
        let gameButton = UIButton(frame: .zero)
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        gameButton.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
        gameButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        gameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //systemFont(ofSize: 30)
        gameButton.setTitle(text, for: .normal)
        gameButton.setTitleColor(.black, for: .normal)
        gameButton.setTitleColor(.white, for: .highlighted)
        return gameButton
    }
}
