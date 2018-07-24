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
        gameButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
        gameButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
        gameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //systemFont(ofSize: 30)
        gameButton.setTitle(text, for: .normal)
        gameButton.setTitleColor(.black, for: .normal)
        gameButton.setTitleColor(.white, for: .highlighted)
        return gameButton
    }
}
