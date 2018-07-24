//
//  GameViewController.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate {
    
    //MARK:- Properties
    var bgAudioPlayer : AVAudioPlayer?
    var audioPlayer : AVAudioPlayer?
    var firstNumber = arc4random_uniform(12) + 1
    var secondNumber = arc4random_uniform(3) + 1
    var lives = 3
    var score = 0
    var highscore = 0
    var pausePressed = 0
    var nightPressed = 0
    var muteCount = 0
    let happyArray = ["Great Job!","Keep it Up!", "Nice!", "Take That!", "WOOHOO!", "Math Punch!", "Bam!", "Pow!"]
    
    //Ad Banner
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //Real
        adBannerView.adUnitID = "ca-app-pub-6279961815562254/1606286445"
        //Sample
        //adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        
        return adBannerView
    }()
    
    //MARK:- UIControls
    
    lazy var gameScene: GameScene = {
        guard let gameScene = GameScene(fileNamed: "GameScene") else {
            fatalError("Could Not load GameScene!")
        }
        return gameScene
    }()
    
    lazy var skView: SKView = {
        let skView = SKView(frame: .zero)
        skView.translatesAutoresizingMaskIntoConstraints = false
        
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
        
        return skView
    }()
    
    lazy var livesImageView: UIImageView = {
        let livesImageView = UIImageView(frame: .zero)
        livesImageView.translatesAutoresizingMaskIntoConstraints = false
        livesImageView.image = #imageLiteral(resourceName: "livesImage")
        
        return livesImageView
    }()
    
    lazy var tauntLabel: UILabel = {
        let tauntLabel = UILabel(frame: .zero)
        tauntLabel.translatesAutoresizingMaskIntoConstraints = false
        tauntLabel.textColor = .clear
        return tauntLabel
    }()
    
    lazy var multiplyLabel: UILabel = {
        let multiplyLabel = UILabel(frame: .zero)
        multiplyLabel.translatesAutoresizingMaskIntoConstraints = false
        multiplyLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 34)
        
        multiplyLabel.textColor = .black
        multiplyLabel.text = "x"
        
        return multiplyLabel
    }()
    
    lazy var numberOneLabel: UILabel = {
        let numberOneLabel = UILabel(frame: .zero)
        numberOneLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOneLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35)
        numberOneLabel.textColor = .black
        numberOneLabel.textAlignment = .right
        numberOneLabel.text = "\(firstNumber)"
        
        return numberOneLabel
    }()
    
    lazy var numberTwoLabel: UILabel = {
        let numberTwoLabel = UILabel(frame: .zero)
        numberTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTwoLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35)
        numberTwoLabel.textColor = .black
        numberTwoLabel.textAlignment = .right
        while (firstNumber < secondNumber) {
            firstNumber = arc4random_uniform(12) + 1
            secondNumber = arc4random_uniform(3) + 1
        }
        numberTwoLabel.text = "\(secondNumber)"
        
        return numberTwoLabel
    }()
    
    lazy var answerLabel: UILabel = {
        let answerLabel = UILabel(frame: .zero)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35)
        answerLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        answerLabel.textAlignment = .center
        answerLabel.textColor = .black
        answerLabel.text = "0"
        
        return answerLabel
    }()
    
    lazy var scoreTextLabel: UILabel = {
        let scoreTextLabel = UILabel(frame: .zero)
        scoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreTextLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        scoreTextLabel.textColor = .black
        scoreTextLabel.text = "Score:"
        
        return scoreTextLabel
    }()
    
    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel(frame: .zero)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        scoreLabel.textColor = .black
        scoreLabel.textAlignment = .right
        scoreLabel.text = "\(score)"
        return scoreLabel
    }()
    
    lazy var highscoreTextLabel: UILabel = {
        let highscoreTextLabel = UILabel(frame: .zero)
        highscoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        highscoreTextLabel.font = UIFont(name: "AvenirNext-Bold", size: 50)
        highscoreTextLabel.textColor = .black
        highscoreTextLabel.text = "Best Score:"
        highscoreTextLabel.textAlignment = .center
        return highscoreTextLabel
    }()
    
    lazy var highscoreLabel: UILabel = {
        let highscoreLabel = UILabel(frame: .zero)
        highscoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highscoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 60)
        highscoreLabel.textColor = .black
        highscoreLabel.textAlignment = .center
        highscoreLabel.text = "0"
        return highscoreLabel
    }()
    
    lazy var livesLabel: UILabel = {
        let livesLabel = UILabel(frame: .zero)
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        livesLabel.textColor = .black
        livesLabel.text = "x \(lives)"
        livesLabel.textAlignment = .right
        
        return livesLabel
    }()
    
    lazy var playAgainButton: UIButton = {
        let playAgainButton = UIButton(frame: .zero)
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.backgroundColor = #colorLiteral(red: 0.4565016739, green: 0.8918543782, blue: 0.6923041558, alpha: 1)
        playAgainButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 40)
        playAgainButton.setTitle("Play Again?", for: .normal)
        playAgainButton.setTitleColor(.black, for: .normal)
        playAgainButton.setTitleColor(.white, for: .highlighted)
        playAgainButton.addTarget(self, action: #selector(userDidPressPlayAgainButton(_:)), for: .touchUpInside)
        return playAgainButton
    }()
    
    lazy var clearButton: UIButton = {
        let clearButton = UIButton.gameButtonWithText(text: "Clear")
        clearButton.addTarget(self, action: #selector(userDidPressClearButton(_:)), for: .touchUpInside)
        
        return clearButton
    }()
    
    lazy var fightButton: UIButton = {
        let fightButton = UIButton.gameButtonWithText(text: "Fight")
        fightButton.addTarget(self, action: #selector(userDidPressFightButton(_:)), for: .touchUpInside)
        
        return fightButton
    }()
    
    lazy var oneButton: UIButton = {
        let oneButton = UIButton.gameButtonWithText(text: "1")
        oneButton.addTarget(self, action: #selector(userDidPressOneButton(_:)), for: .touchUpInside)
        
        return oneButton
    }()
    
    lazy var twoButton: UIButton = {
        let twoButton = UIButton.gameButtonWithText(text: "2")
        twoButton.addTarget(self, action: #selector(userDidPressTwoButton(_:)), for: .touchUpInside)
        
        return twoButton
    }()
    
    lazy var threeButton: UIButton = {
        let threeButton = UIButton.gameButtonWithText(text: "3")
        threeButton.addTarget(self, action: #selector(userDidPressThreeButton(_:)), for: .touchUpInside)
        
        return threeButton
    }()
    
    lazy var fourButton: UIButton = {
        let fourButton = UIButton.gameButtonWithText(text: "4")
        fourButton.addTarget(self, action: #selector(userDidPressFourButton(_:)), for: .touchUpInside)
        
        return fourButton
    }()
    
    lazy var fiveButton: UIButton = {
        let fiveButton = UIButton.gameButtonWithText(text: "5")
        fiveButton.addTarget(self, action: #selector(userDidPressFiveButton(_:)), for: .touchUpInside)
        
        return fiveButton
    }()
    
    lazy var sixButton: UIButton = {
        let sixButton = UIButton.gameButtonWithText(text: "6")
        sixButton.addTarget(self, action: #selector(userDidPressSixButton(_:)), for: .touchUpInside)
        
        return sixButton
    }()
    
    lazy var sevenButton: UIButton = {
        let sevenButton = UIButton.gameButtonWithText(text: "7")
        sevenButton.addTarget(self, action: #selector(userDidPressSevenButton(_:)), for: .touchUpInside)
        
        return sevenButton
    }()
    
    lazy var eightButton: UIButton = {
        let eightButton = UIButton.gameButtonWithText(text: "8")
        eightButton.addTarget(self, action: #selector(userDidPressEightButton(_:)), for: .touchUpInside)
        
        return eightButton
    }()
    
    lazy var nineButton: UIButton = {
        let nineButton = UIButton.gameButtonWithText(text: "9")
        nineButton.addTarget(self, action: #selector(userDidPressNineButton(_:)), for: .touchUpInside)
        
        return nineButton
    }()
    
    lazy var zeroButton: UIButton = {
        let zeroButton = UIButton.gameButtonWithText(text: "0")
        zeroButton.addTarget(self, action: #selector(userDidPressZeroButton(_:)), for: .touchUpInside)
        
        return zeroButton
    }()
    
    lazy var pauseButton: UIButton = {
        let pauseButton = UIButton(frame: .zero)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.backgroundColor = .clear
        pauseButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 22)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.black, for: .normal)
        pauseButton.addTarget(self, action: #selector(userDidPressPauseButton(_:)), for: .touchUpInside)
        pauseButton.isHighlighted = true
        return pauseButton
    }()
    
    lazy var nightButton: UIButton = {
        let nightButton = UIButton(frame: .zero)
        nightButton.translatesAutoresizingMaskIntoConstraints = false
        nightButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
        nightButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 22)
        nightButton.setTitle("🌙 Mode", for: .normal)
        nightButton.isHidden = true
        nightButton.setTitleColor(.black, for: .normal)
        nightButton.setTitleColor(.white, for: .highlighted)
        nightButton.addTarget(self, action: #selector(userDidPressNightButton(_:)), for: .touchUpInside)
        return nightButton
    }()
    
    lazy var muteButton: UIButton = {
        let muteButton = UIButton(frame: .zero)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.backgroundColor = .clear
        muteButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 22)
        muteButton.setTitle("Pause", for: .normal)
        muteButton.setTitleColor(.black, for: .normal)
        muteButton.setTitleColor(.white, for: .highlighted)
        muteButton.addTarget(self, action: #selector(userDidPressPauseButton(_:)), for: .touchUpInside)
        return muteButton
    }()
    
    lazy var startButton: UIButton = {
        let startButton = UIButton(frame: .zero)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
        startButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 22)
        startButton.setTitle("Let's Play", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(.white, for: .highlighted)
        startButton.addTarget(self, action: #selector(userDidPressStartButton(_:)), for: .touchUpInside)
        return startButton
    }()
    //Start Menu
    //userDidPressStartButton
    @objc func userDidPressStartButton(_ sender: UIButton) {
        startButton.isHidden = true
        highscoreLabel.isHidden = true
        highscoreTextLabel.isHidden = true
        showEverything()
    }
    //Pause Menu
    //userDidPressNightButton
    @objc func userDidPressNightButton(_ sender: UIButton) {
        if (nightPressed % 2) == 0 {
            nightButton.setTitle("🌙 Mode", for: .normal)
            nightButton.setTitleColor(.white, for: .normal)
            nightButton.setTitleColor(.black, for: .highlighted)
            pauseButton.setTitleColor(.white, for: .normal)
            view.backgroundColor = .black
            highscoreLabel.textColor = .white
            highscoreTextLabel.textColor = .white
            scoreLabel.textColor = .white
            scoreTextLabel.textColor = .white
            livesLabel.textColor = .white
            playAgainButton.setTitleColor(.white, for: .normal)
            numberOneLabel.textColor = .white
            numberTwoLabel.textColor = .white
            multiplyLabel.textColor = .white
            oneButton.setTitleColor(.white, for: .normal)
            twoButton.setTitleColor(.white, for: .normal)
            threeButton.setTitleColor(.white, for: .normal)
            fourButton.setTitleColor(.white, for: .normal)
            fiveButton.setTitleColor(.white, for: .normal)
            sixButton.setTitleColor(.white, for: .normal)
            sevenButton.setTitleColor(.white, for: .normal)
            eightButton.setTitleColor(.white, for: .normal)
            nineButton.setTitleColor(.white, for: .normal)
            zeroButton.setTitleColor(.white, for: .normal)
            clearButton.setTitleColor(.white, for: .normal)
            fightButton.setTitleColor(.white, for: .normal)
            answerLabel.backgroundColor = .orange
            answerLabel.textColor = .white
            oneButton.setTitleColor(.black, for: .highlighted)
            twoButton.setTitleColor(.black, for: .highlighted)
            threeButton.setTitleColor(.black, for: .highlighted)
            fourButton.setTitleColor(.black, for: .highlighted)
            fiveButton.setTitleColor(.black, for: .highlighted)
            sixButton.setTitleColor(.black, for: .highlighted)
            sevenButton.setTitleColor(.black, for: .highlighted)
            eightButton.setTitleColor(.black, for: .highlighted)
            nineButton.setTitleColor(.black, for: .highlighted)
            zeroButton.setTitleColor(.black, for: .highlighted)
            clearButton.setTitleColor(.black, for: .highlighted)
            fightButton.setTitleColor(.black, for: .highlighted)
            oneButton.backgroundColor = .blue
            twoButton.backgroundColor = .blue
            threeButton.backgroundColor = .blue
            fourButton.backgroundColor = .blue
            fiveButton.backgroundColor = .blue
            sixButton.backgroundColor = .blue
            sevenButton.backgroundColor = .blue
            eightButton.backgroundColor = .blue
            nineButton.backgroundColor = .blue
            zeroButton.backgroundColor = .blue
            clearButton.backgroundColor = .blue
            fightButton.backgroundColor = .blue
            nightPressed = nightPressed + 1
        } else {
            nightButton.setTitle("☀️ Mode", for: .normal)
            view.backgroundColor = .white
            pauseButton.setTitleColor(.black, for: .normal)
            highscoreLabel.textColor = .black
            highscoreTextLabel.textColor = .black
            scoreLabel.textColor = .black
            scoreTextLabel.textColor = .black
            livesLabel.textColor = .black
            playAgainButton.setTitleColor(.black, for: .normal)
            numberOneLabel.textColor = .black
            numberTwoLabel.textColor = .black
            multiplyLabel.textColor = .black
            oneButton.setTitleColor(.black, for: .normal)
            twoButton.setTitleColor(.black, for: .normal)
            threeButton.setTitleColor(.black, for: .normal)
            fourButton.setTitleColor(.black, for: .normal)
            fiveButton.setTitleColor(.black, for: .normal)
            sixButton.setTitleColor(.black, for: .normal)
            sevenButton.setTitleColor(.black, for: .normal)
            eightButton.setTitleColor(.black, for: .normal)
            nineButton.setTitleColor(.black, for: .normal)
            zeroButton.setTitleColor(.black, for: .normal)
            clearButton.setTitleColor(.black, for: .normal)
            fightButton.setTitleColor(.black, for: .normal)
            answerLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            answerLabel.textColor = .black
            oneButton.setTitleColor(.white, for: .highlighted)
            twoButton.setTitleColor(.white, for: .highlighted)
            threeButton.setTitleColor(.white, for: .highlighted)
            fourButton.setTitleColor(.white, for: .highlighted)
            fiveButton.setTitleColor(.white, for: .highlighted)
            sixButton.setTitleColor(.white, for: .highlighted)
            sevenButton.setTitleColor(.white, for: .highlighted)
            eightButton.setTitleColor(.white, for: .highlighted)
            nineButton.setTitleColor(.white, for: .highlighted)
            zeroButton.setTitleColor(.white, for: .highlighted)
            clearButton.setTitleColor(.white, for: .highlighted)
            fightButton.setTitleColor(.white, for: .highlighted)
            oneButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            twoButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            threeButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            fourButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            fiveButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            sixButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            sevenButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            eightButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            nineButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            zeroButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            clearButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            fightButton.backgroundColor = #colorLiteral(red: 0.004916466353, green: 0.9297073287, blue: 0.9222952659, alpha: 1)
            nightPressed = nightPressed + 1
        }
    }
    
    //userDidPressPauseButton
    @objc func userDidPressPauseButton(_ sender: UIButton) {
        if (pausePressed % 2) == 0 {
            gameScene.isPaused = true
            nightButton.isHidden = false
            pauseButton.setTitle("Resume", for: .normal)
            highscoreLabel.isHidden = false
            highscoreTextLabel.isHidden = false
            hideEverything();
            scoreLabel.isHidden = false
            scoreTextLabel.isHidden = false
            livesImageView.isHidden = false
            livesLabel.isHidden = false
            pauseButton.isHidden = false
            playAgainButton.isHidden = false
            playAgainButton.setTitle("Restart", for: .normal)
            answerLabel.isHidden = true;
            pausePressed = pausePressed + 1
        } else {
            gameScene.isPaused = false
            nightButton.isHidden = true
            highscoreLabel.isHidden = true
            highscoreTextLabel.isHidden = true
            pauseButton.setTitle("Pause", for: .normal)
            tauntLabel.isHidden = true
            numberOneLabel.isHidden = false
            numberTwoLabel.isHidden = false
            multiplyLabel.isHidden = false
            oneButton.isHidden = false
            twoButton.isHidden = false
            threeButton.isHidden = false
            fourButton.isHidden = false
            fiveButton.isHidden = false
            sixButton.isHidden = false
            sevenButton.isHidden = false
            eightButton.isHidden = false
            nineButton.isHidden = false
            zeroButton.isHidden = false
            clearButton.isHidden = false
            fightButton.isHidden = false
            playAgainButton.isHidden = true
            playAgainButton.setTitle("Play Again?", for: .normal)
            answerLabel.isHidden = false;
            pausePressed = pausePressed + 1
        }
    }
    //MARK: Target Action
    
    @objc func userDidPressPlayAgainButton(_ sender: UIButton) {
        gameScene.playedAgain()
        highscoreLabel.isHidden = true
        highscoreTextLabel.isHidden = true
        scoreLabel.isHidden = false
        scoreTextLabel.isHidden = false
        gameScene.isPaused = false
        pauseButton.setTitle("Pause", for: .normal)
        pausePressed = 0
        lives = 3
        livesLabel.text = "x " + lives.description
        score = 0
        scoreLabel.text = "\(score)"
        answerLabel.isHidden = false;
        numberOneLabel.isHidden = false
        numberTwoLabel.isHidden = false
        multiplyLabel.isHidden = false
        oneButton.isHidden = false
        twoButton.isHidden = false
        threeButton.isHidden = false
        fourButton.isHidden = false
        fiveButton.isHidden = false
        sixButton.isHidden = false
        sevenButton.isHidden = false
        eightButton.isHidden = false
        nineButton.isHidden = false
        zeroButton.isHidden = false
        clearButton.isHidden = false
        fightButton.isHidden = false
        tauntLabel.isHidden = true
        playAgainButton.isHidden = true
        pauseButton.isHidden = false
        firstNumber = arc4random_uniform(12) + 1
        secondNumber = arc4random_uniform(12) + 1
        numberOneLabel.text = firstNumber.description
        numberTwoLabel.text = secondNumber.description
        answerLabel.text = "0"
        nightButton.isHidden = true
    }
    
    @objc func userDidPressClearButton(_ sender: UIButton) {
        answerLabel.text = "0"
    }
    
    @objc func userDidPressFightButton(_ sender: UIButton) {
        let answer = Int32(answerLabel.text!);
        livesLabel.text = "x " + lives.description
        if answer! != (firstNumber * secondNumber) {
            playIncorrectSound()
            lives = lives - 1
            gameScene.incorrect(firstNumber: Int(firstNumber), secondNumber: Int(secondNumber))
            if lives == -1 {
                gameOver()
            } else {
                livesLabel.text = "x " + lives.description
                if score >= 25 && score < 50 {
                    firstNumber = arc4random_uniform(15) + 1
                    secondNumber = arc4random_uniform(5) + 1
                    while(firstNumber < secondNumber) {
                        firstNumber = arc4random_uniform(15) + 1
                        secondNumber = arc4random_uniform(5) + 1
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else if (score >= 50 && score < 75) {
                    firstNumber = arc4random_uniform(19) + 1
                    secondNumber = arc4random_uniform(12) + 1
                    while(firstNumber < secondNumber) {
                        firstNumber = arc4random_uniform(19) + 1
                        secondNumber = arc4random_uniform(12) + 1
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else if score >= 75 && score < 100 {
                    firstNumber = arc4random_uniform(25) + 1
                    secondNumber = arc4random_uniform(15) + 1
                    while(firstNumber < secondNumber) {
                        firstNumber = arc4random_uniform(25) + 1
                        secondNumber = arc4random_uniform(15) + 1
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else if score >= 100 {
                    firstNumber = arc4random_uniform(25) + 1
                    secondNumber = arc4random_uniform(25) + 1
                    while(firstNumber < secondNumber) {
                        firstNumber = arc4random_uniform(25) + 1
                        secondNumber = arc4random_uniform(25) + 1
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else {
                    firstNumber = arc4random_uniform(12) + 1
                    secondNumber = arc4random_uniform(3) + 1
                    while(firstNumber < secondNumber) {
                        firstNumber = arc4random_uniform(12) + 1
                        secondNumber = arc4random_uniform(3) + 1
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                }
            }
        } else {
            playCorrectSound()
            score = score + 1
            gameScene.correct(score: score)
            if score >= 25 && score < 50 {
                firstNumber = arc4random_uniform(15) + 1
                secondNumber = arc4random_uniform(5) + 1
                while(firstNumber < secondNumber) {
                    firstNumber = arc4random_uniform(15) + 1
                    secondNumber = arc4random_uniform(5) + 1
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else if (score >= 50 && score < 75) {
                firstNumber = arc4random_uniform(19) + 1
                secondNumber = arc4random_uniform(12) + 1
                while(firstNumber < secondNumber) {
                    firstNumber = arc4random_uniform(19) + 1
                    secondNumber = arc4random_uniform(12) + 1
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else if score >= 75 && score < 100 {
                firstNumber = arc4random_uniform(25) + 1
                secondNumber = arc4random_uniform(15) + 1
                while(firstNumber < secondNumber) {
                    firstNumber = arc4random_uniform(25) + 1
                    secondNumber = arc4random_uniform(15) + 1
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else if score > 100 {
                firstNumber = arc4random_uniform(25) + 1
                secondNumber = arc4random_uniform(25) + 1
                while(firstNumber < secondNumber) {
                    firstNumber = arc4random_uniform(25) + 1
                    secondNumber = arc4random_uniform(25) + 1
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else {
                firstNumber = arc4random_uniform(12) + 1
                secondNumber = arc4random_uniform(3) + 1
                while(firstNumber < secondNumber) {
                    firstNumber = arc4random_uniform(12) + 1
                    secondNumber = arc4random_uniform(3) + 1
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            }
        }
    }
    
    @objc func userDidPressZeroButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 0)
    }
    
    @objc func userDidPressOneButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 1)
    }
    
    @objc func userDidPressTwoButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 2)
    }
    
    @objc func userDidPressThreeButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 3)
    }
    
    @objc func userDidPressFourButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 4)
    }
    
    @objc func userDidPressFiveButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 5)
    }
    
    @objc func userDidPressSixButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 6)
    }
    
    @objc func userDidPressSevenButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 7)
    }
    
    @objc func userDidPressEightButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 8)
    }
    
    @objc func userDidPressNineButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 9)
    }
    
    //MARK: Helper Methods
    
    func appendValueToAnswerLabel(value: Int) {
        guard let text = answerLabel.text, let number = Int("\(text)\(value)") else {
            print("An error occurred while updating the answerLabel.")
            return
        }
        
        answerLabel.text = "\(number)"
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func solveEquation(firstNumber: Int, secondNumber: Int) -> String {
        return "\(firstNumber) x \(secondNumber) = \(firstNumber * secondNumber)"
    }
    
    func gameOver() {
        gameScene.gameOver()
        if score > highscore {
            highscore = score
            highscoreLabel.text = "\(highscore)"
            let highscoreDefaults = UserDefaults.standard
            highscoreDefaults.set(highscore, forKey: "highscore")
            highscoreDefaults.synchronize()
        }
        highscoreLabel.isHidden = false
        highscoreTextLabel.isHidden = false
        playAgainButton.setTitle("Play Again?", for: .normal)
        hideEverything()
        playAgainButton.isHidden = false
        livesLabel.isHidden = false
        livesImageView.isHidden = false
        livesLabel.text = "x 0"
        answerLabel.isHidden = true;
    }
    
    func hideEverything() {
        pauseButton.isHidden = true
        tauntLabel.isHidden = true
        numberOneLabel.isHidden = true
        numberTwoLabel.isHidden = true
        multiplyLabel.isHidden = true
        oneButton.isHidden = true
        twoButton.isHidden = true
        threeButton.isHidden = true
        fourButton.isHidden = true
        fiveButton.isHidden = true
        sixButton.isHidden = true
        sevenButton.isHidden = true
        eightButton.isHidden = true
        nineButton.isHidden = true
        zeroButton.isHidden = true
        clearButton.isHidden = true
        fightButton.isHidden = true
        playAgainButton.isHidden = true
        livesLabel.isHidden = true
        livesImageView.isHidden = true
        answerLabel.isHidden = true
        scoreLabel.isHidden = true
        scoreTextLabel.isHidden = true
    }
    
    func showEverything() {
        pauseButton.isHidden = false
        tauntLabel.isHidden = true
        numberOneLabel.isHidden = false
        numberTwoLabel.isHidden = false
        multiplyLabel.isHidden = false
        oneButton.isHidden = false
        twoButton.isHidden = false
        threeButton.isHidden = false
        fourButton.isHidden = false
        fiveButton.isHidden = false
        sixButton.isHidden = false
        sevenButton.isHidden = false
        eightButton.isHidden = false
        nineButton.isHidden = false
        zeroButton.isHidden = false
        clearButton.isHidden = false
        fightButton.isHidden = false
        playAgainButton.isHidden = true
        livesLabel.isHidden = false
        livesImageView.isHidden = false
        answerLabel.isHidden = false
        scoreLabel.isHidden = false
        scoreTextLabel.isHidden = false
    }
    
    func playCorrectSound() {
        let url = Bundle.main.url(forResource: "correct", withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playIncorrectSound() {
        let url = Bundle.main.url(forResource: "incorrect", withExtension: "mp3")!
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else { return }
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playBackSound() {
        let url = Bundle.main.url(forResource: "bgaudio", withExtension: "mp3")!
        
        do {
            bgAudioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let bgAudioPlayer = bgAudioPlayer else { return }
            
            bgAudioPlayer.prepareToPlay()
            bgAudioPlayer.numberOfLoops = -1
            bgAudioPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide.bottomAnchor,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        adBannerView = bannerView
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    //MARK:- View Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        adBannerView.load(GADRequest())
        
        let highscoreDefaults = UserDefaults.standard
        if highscoreDefaults.value(forKey: "highscore") != nil {
            highscore = highscoreDefaults.value(forKey: "highscore") as! Int
            highscoreLabel.text = "\(highscore)"
        }
        playBackSound()
        hideEverything()
        startButton.isHidden = false
        // Layout.
        let scoreBoardStackView = UIStackView()
        scoreBoardStackView.translatesAutoresizingMaskIntoConstraints = false
        scoreBoardStackView.axis = .horizontal
        scoreBoardStackView.spacing = 10
        scoreBoardStackView.alignment = .fill
        scoreBoardStackView.distribution = .fill
        
        scoreBoardStackView.addArrangedSubview(scoreTextLabel)
        scoreBoardStackView.addArrangedSubview(scoreLabel)
        
        let lifeStackView = UIStackView()
        lifeStackView.translatesAutoresizingMaskIntoConstraints = false
        lifeStackView.axis = .horizontal
        lifeStackView.spacing = 10
        lifeStackView.alignment = .fill
        lifeStackView.distribution = .fill
        
        lifeStackView.addArrangedSubview(livesImageView)
        lifeStackView.addArrangedSubview(livesLabel)
        
        let headerStackView = UIStackView()
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .horizontal
        headerStackView.spacing = 10
        headerStackView.alignment = .fill
        headerStackView.distribution = .equalSpacing
        
        headerStackView.addArrangedSubview(scoreBoardStackView)
        headerStackView.addArrangedSubview(pauseButton)
        headerStackView.addArrangedSubview(lifeStackView)
        view.addSubview(headerStackView)
        
        view.addSubview(tauntLabel)
        
        view.addSubview(skView)
        
        let multiplicationStackView = UIStackView()
        multiplicationStackView.translatesAutoresizingMaskIntoConstraints = false
        multiplicationStackView.axis = .vertical
        multiplicationStackView.spacing = 10
        multiplicationStackView.alignment = .fill
        multiplicationStackView.distribution = .fill
        multiplicationStackView.addArrangedSubview(highscoreTextLabel)
        multiplicationStackView.addArrangedSubview(highscoreLabel)
        multiplicationStackView.addArrangedSubview(numberOneLabel)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(multiplyLabel)
        stackView.addArrangedSubview(numberTwoLabel)
        stackView.addArrangedSubview(startButton)
        multiplicationStackView.addArrangedSubview(stackView)
        
        view.addSubview(multiplicationStackView)
        let fourthButtonStackView = UIStackView.horizontalStackViewWithButtons(buttons: [clearButton, zeroButton, fightButton])
        let thirdButtonStackView = UIStackView.horizontalStackViewWithButtons(buttons: [oneButton, twoButton, threeButton])
        let secondButtonStackView = UIStackView.horizontalStackViewWithButtons(buttons: [fourButton, fiveButton, sixButton])
        let firstButtonStackView = UIStackView.horizontalStackViewWithButtons(buttons: [sevenButton, eightButton, nineButton])
        
        let verticalButtonStackView = UIStackView()
        verticalButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalButtonStackView.axis = .vertical
        verticalButtonStackView.spacing = 10
        verticalButtonStackView.alignment = .fill
        verticalButtonStackView.distribution = .fill
        
        verticalButtonStackView.addArrangedSubview(answerLabel)
        playAgainButton.isHidden = true
        verticalButtonStackView.addArrangedSubview(playAgainButton)
        verticalButtonStackView.addArrangedSubview(nightButton)
        verticalButtonStackView.addArrangedSubview(firstButtonStackView)
        verticalButtonStackView.addArrangedSubview(secondButtonStackView)
        verticalButtonStackView.addArrangedSubview(thirdButtonStackView)
        verticalButtonStackView.addArrangedSubview(fourthButtonStackView)
        verticalButtonStackView.addArrangedSubview(adBannerView)
        view.addSubview(verticalButtonStackView)
        var constraints = [NSLayoutConstraint]()
        
        // Layout Header Stack View.
        constraints.append(headerStackView.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0))
        constraints.append(headerStackView.leadingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0))
        constraints.append(view.safeAreaLayoutGuide.trailingAnchor.constraintEqualToSystemSpacingAfter(headerStackView.trailingAnchor, multiplier: 1.0))
        
        // Layout Taunt Label.
        constraints.append(tauntLabel.topAnchor.constraintEqualToSystemSpacingBelow(headerStackView.bottomAnchor, multiplier: 1.0))
        constraints.append(tauntLabel.leadingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0))
        constraints.append(view.safeAreaLayoutGuide.trailingAnchor.constraintEqualToSystemSpacingAfter(tauntLabel.trailingAnchor, multiplier: 1.0))
        
        // Layout skView with our game scene.
        constraints.append(skView.topAnchor.constraintEqualToSystemSpacingBelow(tauntLabel.bottomAnchor, multiplier: 1.0))
        constraints.append(skView.leadingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0))
        constraints.append(view.safeAreaLayoutGuide.trailingAnchor.constraintEqualToSystemSpacingAfter(skView.trailingAnchor, multiplier: 1.0))
        
        // Layout Multiplication Stack View.
        constraints.append(multiplicationStackView.topAnchor.constraintEqualToSystemSpacingBelow(skView.bottomAnchor, multiplier: 1.0))
        constraints.append(multiplicationStackView.leadingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0))
        constraints.append(view.safeAreaLayoutGuide.trailingAnchor.constraintEqualToSystemSpacingAfter(multiplicationStackView.trailingAnchor, multiplier: 1.0))
        
        // Layout Vertical Button Stack View.
        constraints.append(verticalButtonStackView.topAnchor.constraintEqualToSystemSpacingBelow(multiplicationStackView.bottomAnchor, multiplier: 1.0))
        constraints.append(view.safeAreaLayoutGuide.bottomAnchor.constraintEqualToSystemSpacingBelow(verticalButtonStackView.bottomAnchor, multiplier: 1.0))
        constraints.append(verticalButtonStackView.leadingAnchor.constraintEqualToSystemSpacingAfter(view.safeAreaLayoutGuide.leadingAnchor, multiplier: 1.0))
        constraints.append(view.safeAreaLayoutGuide.trailingAnchor.constraintEqualToSystemSpacingAfter(verticalButtonStackView.trailingAnchor, multiplier: 1.0))
        NSLayoutConstraint.activate(constraints)
    }
}
