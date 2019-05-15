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
import GameKit
import StoreKit

/// The GameViewController Class Contains the Game Content and Rules
class GameViewController: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate {
    //Game Center Integration
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    let LEADERBOARD_ID = "com.score.multiplyninja"
    /// Audio Controller
    var bgAudioPlayer : AVAudioPlayer?
    var audioPlayer : AVAudioPlayer?
    /// Game Properties
    var firstNumber = arc4random_uniform(12) + 1
    var secondNumber = arc4random_uniform(3) + 1
    var startPressed = 0
    var lives = 3
    var score = 0
    var highscore = 0
    var pausePressed = 0
    var nightPressed = 1
    var isMute = false
    var muteCount = 1
    var previousAnswer = 0
    var allButtons = [UIButton]()
    /// The interstitial ad
    var interstitial: GADInterstitial!
    /// Banner Ad
    lazy var adBannerView: GADBannerView = {
        let adBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        //Real
        adBannerView.adUnitID = "ca-app-pub-6279961815562254/1606286445"
        //Sample
        //adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        return adBannerView
    }()
    
    //MARK:- UIControls
    
    /// The Game Scene that contains the Sprites and methods to interact with it
    lazy var gameScene: GameScene = {
        guard let gameScene = GameScene(fileNamed: "GameScene") else {
            fatalError("Could Not load GameScene!")
        }
        return gameScene
    }()
    
    /// The view that is displayed to the user
    lazy var skView: SKView = {
        let skView = SKView(frame: .zero)
        skView.translatesAutoresizingMaskIntoConstraints = false
        skView.layer.shadowColor = UIColor.black.cgColor
        skView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        skView.layer.masksToBounds = false
        skView.layer.shadowRadius = 2.0
        skView.layer.shadowOpacity = 0.5
        skView.layer.cornerRadius = skView.frame.width/2
        skView.layer.borderColor = UIColor.black.cgColor
        skView.layer.borderWidth = 2.0
        gameScene.scaleMode = .aspectFill
        skView.presentScene(gameScene)
        return skView
    }()
    
    //MARK:- Header of the View
    
    /// The Lives Image View
    lazy var livesImageView: UIImageView = {
        let livesImageView = UIImageView(frame: .zero)
        livesImageView.translatesAutoresizingMaskIntoConstraints = false
        livesImageView.image = #imageLiteral(resourceName: "livesImage")
        return livesImageView
    }()
    
    /// The lives of the user
    lazy var livesLabel: UILabel = {
        let livesLabel = UILabel(frame: .zero)
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        livesLabel.textColor = .black
        livesLabel.text = "x \(lives)"
        livesLabel.textAlignment = .right
        
        return livesLabel
    }()
    
    /// This label represents a title for the score itself
    lazy var scoreTextLabel: UILabel = {
        let scoreTextLabel = UILabel(frame: .zero)
        scoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreTextLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        scoreTextLabel.textColor = .black
        scoreTextLabel.text = "Score:"
        return scoreTextLabel
    }()
    
    /// This label contains the score of the user
    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel(frame: .zero)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 20)
        scoreLabel.textColor = .black
        scoreLabel.textAlignment = .right
        scoreLabel.text = "\(score)"
        return scoreLabel
    }()
    
    /// This label represents a title for the highscore itself
    lazy var highscoreTextLabel: UILabel = {
        let highscoreTextLabel = UILabel(frame: .zero)
        highscoreTextLabel.translatesAutoresizingMaskIntoConstraints = false
        highscoreTextLabel.font = UIFont(name: "AvenirNext-Bold", size: 30)
        highscoreTextLabel.textColor = .black
        highscoreTextLabel.text = "Best Score:"
        highscoreTextLabel.textAlignment = .center
        return highscoreTextLabel
    }()
    
    /// This label contains the highscore of the user
    lazy var highscoreLabel: UILabel = {
        let highscoreLabel = UILabel(frame: .zero)
        highscoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highscoreLabel.font = UIFont(name: "AvenirNext-Bold", size: 35)
        highscoreLabel.textColor = .black
        highscoreLabel.textAlignment = .center
        highscoreLabel.text = "0"
        return highscoreLabel
    }()
    
    //MARK:- The Equation Section
    
    /// This label represents the first number to multiply
    lazy var numberOneLabel: UILabel = {
        let numberOneLabel = UILabel(frame: .zero)
        numberOneLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOneLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
        numberOneLabel.textColor = .black
        numberOneLabel.textAlignment = .right
        numberOneLabel.text = "\(firstNumber)"
        return numberOneLabel
    }()
    
    /// This label represents the second number to multiply
    lazy var numberTwoLabel: UILabel = {
        let numberTwoLabel = UILabel(frame: .zero)
        numberTwoLabel.translatesAutoresizingMaskIntoConstraints = false
        numberTwoLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
        numberTwoLabel.textColor = .black
        numberTwoLabel.textAlignment = .right
        while (firstNumber < secondNumber) {
            firstNumber = arc4random_uniform(12) + 1
            secondNumber = arc4random_uniform(3) + 1
        }
        numberTwoLabel.text = "\(secondNumber)"
        return numberTwoLabel
    }()
    
    /// This label represents the multiplication symbol
    lazy var multiplyLabel: UILabel = {
        let multiplyLabel = UILabel(frame: .zero)
        multiplyLabel.translatesAutoresizingMaskIntoConstraints = false
        multiplyLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
        multiplyLabel.textColor = .black
        multiplyLabel.text = "x"
        return multiplyLabel
    }()
    /// This label is to represent the equal sign
    lazy var equalLabel: UILabel = {
        let equalLabel = UILabel(frame: .zero)
        equalLabel.translatesAutoresizingMaskIntoConstraints = false
        equalLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 24)
        equalLabel.textColor = .black
        equalLabel.text = "="
        return equalLabel
    }()
    
    /// This label is where the answer is inputted by the user
    lazy var answerLabel: UILabel = {
        let answerLabel = UILabel(frame: .zero)
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
        answerLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        answerLabel.textAlignment = .center
        answerLabel.textColor = .black
        answerLabel.text = "0"
        //Making Label Circular
        answerLabel.layer.shadowColor = UIColor.black.cgColor
        answerLabel.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        answerLabel.layer.masksToBounds = false
        answerLabel.layer.shadowRadius = 2.0
        answerLabel.layer.shadowOpacity = 0.5
        answerLabel.layer.cornerRadius = answerLabel.frame.width/2
        answerLabel.layer.borderColor = UIColor.black.cgColor
        answerLabel.layer.borderWidth = 2.0
        return answerLabel
    }()
    
    //MARK:- Keypad
    
    /// The UIButton for inputting 1 into the answerLabel
    lazy var oneButton: UIButton = {
        let oneButton = UIButton.gameButtonWithText(text: "1")
        oneButton.addTarget(self, action: #selector(userDidPressOneButton(_:)), for: .touchUpInside)
        return oneButton
    }()
    
    /// The UIButton for inputting 2 into the answerLabel
    lazy var twoButton: UIButton = {
        let twoButton = UIButton.gameButtonWithText(text: "2")
        twoButton.addTarget(self, action: #selector(userDidPressTwoButton(_:)), for: .touchUpInside)
        return twoButton
    }()
    
    /// The UIButton for inputting 3 into the answerLabel
    lazy var threeButton: UIButton = {
        let threeButton = UIButton.gameButtonWithText(text: "3")
        threeButton.addTarget(self, action: #selector(userDidPressThreeButton(_:)), for: .touchUpInside)
        return threeButton
    }()
    
    /// The UIButton for inputting 4 into the answerLabel
    lazy var fourButton: UIButton = {
        let fourButton = UIButton.gameButtonWithText(text: "4")
        fourButton.addTarget(self, action: #selector(userDidPressFourButton(_:)), for: .touchUpInside)
        return fourButton
    }()
    
    /// The UIButton for inputting 5 into the answerLabel
    lazy var fiveButton: UIButton = {
        let fiveButton = UIButton.gameButtonWithText(text: "5")
        fiveButton.addTarget(self, action: #selector(userDidPressFiveButton(_:)), for: .touchUpInside)
        return fiveButton
    }()
    
    /// The UIButton for inputting 6 into the answerLabel
    lazy var sixButton: UIButton = {
        let sixButton = UIButton.gameButtonWithText(text: "6")
        sixButton.addTarget(self, action: #selector(userDidPressSixButton(_:)), for: .touchUpInside)
        return sixButton
    }()
    
    /// The UIButton for inputting 7 into the answerLabel
    lazy var sevenButton: UIButton = {
        let sevenButton = UIButton.gameButtonWithText(text: "7")
        sevenButton.addTarget(self, action: #selector(userDidPressSevenButton(_:)), for: .touchUpInside)
        return sevenButton
    }()
    
    /// The UIButton for inputting 8 into the answerLabel
    lazy var eightButton: UIButton = {
        let eightButton = UIButton.gameButtonWithText(text: "8")
        eightButton.addTarget(self, action: #selector(userDidPressEightButton(_:)), for: .touchUpInside)
        return eightButton
    }()
    
    /// The UIButton for inputting 9 into the answerLabel
    lazy var nineButton: UIButton = {
        let nineButton = UIButton.gameButtonWithText(text: "9")
        nineButton.addTarget(self, action: #selector(userDidPressNineButton(_:)), for: .touchUpInside)
        return nineButton
    }()
    
    /// The UIButton for inputting 0 into the answerLabel
    lazy var zeroButton: UIButton = {
        let zeroButton = UIButton.gameButtonWithText(text: "0")
        zeroButton.addTarget(self, action: #selector(userDidPressZeroButton(_:)), for: .touchUpInside)
        return zeroButton
    }()
    
    /// The UIButton for clearing the answerLabel
    lazy var clearButton: UIButton = {
        let clearButton = UIButton.gameButtonWithText(text: "Clear")
        clearButton.addTarget(self, action: #selector(userDidPressClearButton(_:)), for: .touchUpInside)
        return clearButton
    }()
    
    /// The UIButton for submitting the contents of the answerLabel as an answer
    lazy var fightButton: UIButton = {
        let fightButton = UIButton.gameButtonWithText(text: "Fight")
        fightButton.addTarget(self, action: #selector(userDidPressFightButton(_:)), for: .touchUpInside)
        return fightButton
    }()
    
    //MARK:- The Pause Menu
    
    /// The UIButton that pauses the gameplay upon user press
    lazy var pauseButton: UIButton = {
        let pauseButton = UIButton(frame: .zero)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.backgroundColor = .clear
        pauseButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 15)
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.black, for: .normal)
        pauseButton.addTarget(self, action: #selector(userDidPressPauseButton(_:)), for: .touchUpInside)
        pauseButton.isHighlighted = true
        return pauseButton
    }()
    
    /// UIButton that resets the game when pressed
    lazy var playAgainButton: UIButton = {
        let playAgainButton = UIButton(frame: .zero)
        playAgainButton.translatesAutoresizingMaskIntoConstraints = false
        playAgainButton.backgroundColor = #colorLiteral(red: 0.4565016739, green: 0.8918543782, blue: 0.6923041558, alpha: 1)
        playAgainButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 30)
        playAgainButton.setTitle("Play Again?", for: .normal)
        playAgainButton.setTitleColor(.black, for: .normal)
        playAgainButton.setTitleColor(.white, for: .highlighted)
        //Making Button Circular
        playAgainButton.layer.shadowColor = UIColor.black.cgColor
        playAgainButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        playAgainButton.layer.masksToBounds = false
        playAgainButton.layer.shadowRadius = 2.0
        playAgainButton.layer.shadowOpacity = 0.5
        playAgainButton.layer.cornerRadius = 20
        playAgainButton.layer.borderColor = UIColor.black.cgColor
        playAgainButton.layer.borderWidth = 2.0
        playAgainButton.addTarget(self, action: #selector(userDidPressPlayAgainButton(_:)), for: .touchUpInside)
        return playAgainButton
    }()
    
    /// UIButton that changes the display colors when pressed
    lazy var nightButton: UIButton = {
        let nightButton = UIButton(frame: .zero)
        nightButton.translatesAutoresizingMaskIntoConstraints = false
        nightButton.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
        nightButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 15)
        nightButton.setTitle("🌙 Mode", for: .normal)
        nightButton.isHidden = true
        nightButton.setTitleColor(.black, for: .normal)
        nightButton.setTitleColor(.white, for: .highlighted)
        //Making Button Circular
        nightButton.layer.shadowColor = UIColor.black.cgColor
        nightButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        nightButton.layer.masksToBounds = false
        nightButton.layer.shadowRadius = 2.0
        nightButton.layer.shadowOpacity = 0.5
        nightButton.layer.cornerRadius = 20
        nightButton.layer.borderColor = UIColor.black.cgColor
        nightButton.layer.borderWidth = 2.0
        nightButton.addTarget(self, action: #selector(userDidPressNightButton(_:)), for: .touchUpInside)
        return nightButton
    }()
    
    /// UIButton that changes mutes/unmutes the audio of the app when pressed
    lazy var muteButton: UIButton = {
        let muteButton = UIButton(frame: .zero)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
        muteButton.isHidden = true
        muteButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 15)
        muteButton.setTitle("Mute", for: .normal)
        muteButton.setTitleColor(.black, for: .normal)
        muteButton.setTitleColor(.white, for: .highlighted)
        //Making Button Circular
        muteButton.layer.shadowColor = UIColor.black.cgColor
        muteButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        muteButton.layer.masksToBounds = false
        muteButton.layer.shadowRadius = 2.0
        muteButton.layer.shadowOpacity = 0.5
        muteButton.layer.cornerRadius = 20
        muteButton.layer.borderColor = UIColor.black.cgColor
        muteButton.layer.borderWidth = 2.0
        muteButton.addTarget(self, action: #selector(userDidPressMuteButton(_:)), for: .touchUpInside)
        return muteButton
    }()
    
    //MARK:- Start Menu
    
    /// UIButton that starts the game
    lazy var startButton: UIButton = {
        let startButton = UIButton(frame: .zero)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
        startButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 15)
        startButton.setTitle("Let's Play", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.setTitleColor(.white, for: .highlighted)
        //Making Button Circular
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        startButton.layer.masksToBounds = false
        startButton.layer.shadowRadius = 2.0
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.cornerRadius = 20
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 2.0
        startButton.addTarget(self, action: #selector(userDidPressStartButton(_:)), for: .touchUpInside)
        return startButton
    }()
    
    /// UIButton that pulls up the Leaderboard from Gamecenter
    lazy var checkLeaderboardButton: UIButton = {
        let checkLeaderboardButton = UIButton(frame: .zero)
        checkLeaderboardButton.translatesAutoresizingMaskIntoConstraints = false
        checkLeaderboardButton.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
        checkLeaderboardButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 15)
        checkLeaderboardButton.setTitle("Check Leaderboard", for: .normal)
        checkLeaderboardButton.setTitleColor(.black, for: .normal)
        checkLeaderboardButton.setTitleColor(.white, for: .highlighted)
        //Making Button Circular
        checkLeaderboardButton.layer.shadowColor = UIColor.black.cgColor
        checkLeaderboardButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        checkLeaderboardButton.layer.masksToBounds = false
        checkLeaderboardButton.layer.shadowRadius = 2.0
        checkLeaderboardButton.layer.shadowOpacity = 0.5
        checkLeaderboardButton.layer.cornerRadius = 20
        checkLeaderboardButton.layer.borderColor = UIColor.black.cgColor
        checkLeaderboardButton.layer.borderWidth = 2.0
        checkLeaderboardButton.addTarget(self, action: #selector(userDidPressCKLeaderboardButton(_:)), for: .touchUpInside)
        return checkLeaderboardButton
    }()
    
    //MARK:- Actions for the each UIButton
    
    //MARK:-Start Menu Actions
    
    /// Action that occurs when the start button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressStartButton(_ sender: UIButton) {
        let startDefaults = UserDefaults.standard
        startDefaults.set(startPressed, forKey: "startPressed")
        startDefaults.synchronize()
        gameScene.skyCheck(nightCount: nightPressed)
        checkLeaderboardButton.isHidden = true
        startButton.layer.cornerRadius = 20
        
        if startPressed == 1 {
            let achievement = GKAchievement(identifier: "startAdv")
            achievement.percentComplete = Double(score / 5)
            achievement.showsCompletionBanner = true  // use Game Center's UI
            GKAchievement.report([achievement], withCompletionHandler: nil)
        } else if startPressed == 10 {
            let achievement = GKAchievement(identifier: "beenNice")
            achievement.percentComplete = Double(score / 5)
            achievement.showsCompletionBanner = true  // use Game Center's UI
            GKAchievement.report([achievement], withCompletionHandler: nil)
        } else if startPressed == 20 {
            let achievement = GKAchievement(identifier: "beenWhile")
            achievement.percentComplete = Double(score / 10)
            achievement.showsCompletionBanner = true  // use Game Center's UI
            GKAchievement.report([achievement], withCompletionHandler: nil)
        } else if startPressed == 50 {
            let achievement = GKAchievement(identifier: "beenLong")
            achievement.percentComplete = Double(score / 10)
            achievement.showsCompletionBanner = true  // use Game Center's UI
            GKAchievement.report([achievement], withCompletionHandler: nil)
        } else if startPressed == 100 {
            let achievement = GKAchievement(identifier: "superLong")
            achievement.percentComplete = Double(score / 20)
            achievement.showsCompletionBanner = true  // use Game Center's UI
            GKAchievement.report([achievement], withCompletionHandler: nil)
        }
        startButton.isHidden = true
        highscoreLabel.isHidden = true
        highscoreTextLabel.isHidden = true
        checkLeaderboardButton.isHidden = true
        startPressed = startPressed + 1
        showEverything()
    }
    
    /// Action that occurs when the Check Leaderboard button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressCKLeaderboardButton(_ sender: UIButton) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
    
    //MARK:-Pause Menu Actions
    
    /// Action that occurs when the pause button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressPauseButton(_ sender: UIButton) {
        if (pausePressed % 2) == 0 {
            gameScene.isPaused = true
            checkLeaderboardButton.isHidden = false
            nightButton.isHidden = false
            muteButton.isHidden = false
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
        } else {
            gameScene.isPaused = false
            checkLeaderboardButton.isHidden = true
            muteButton.isHidden = true
            nightButton.isHidden = true
            highscoreLabel.isHidden = true
            highscoreTextLabel.isHidden = true
            pauseButton.setTitle("Pause", for: .normal)
            numberOneLabel.isHidden = false
            numberTwoLabel.isHidden = false
            multiplyLabel.isHidden = false
            equalLabel.isHidden = false
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
        }
        pausePressed = pausePressed + 1
    }
    
    /// Action that occurs when the mute button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressMuteButton(_ sender: UIButton) {
        muteCount = muteCount + 1
        let muteDefaults = UserDefaults.standard
        muteDefaults.set(muteCount, forKey: "mutePressed")
        muteDefaults.synchronize()
        muteHandle()
    }
    
    /// Action that occurs when the night button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressNightButton(_ sender: UIButton) {
        nightPressed = nightPressed + 1
        let nightDefaults = UserDefaults.standard
        nightDefaults.set(nightPressed, forKey: "nightPressed")
        nightDefaults.synchronize()
        nightHandle()
    }
    
    /// Action that occurs when the play again/reset button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressPlayAgainButton(_ sender: UIButton) {
        gameScene.playedAgain()
        interstitial = createAndLoadInterstitial()
        let startDefaults = UserDefaults.standard
        startDefaults.set(startPressed, forKey: "startPressed")
        startDefaults.synchronize()
        startPressed = startPressed + 1
        checkLeaderboardButton.isHidden = true
        highscoreLabel.isHidden = true
        muteButton.isHidden = true
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
        equalLabel.isHidden = false
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
        pauseButton.isHidden = false
        livesLabel.isHidden = false
        livesImageView.isHidden = false
        firstNumber = arc4random_uniform(12) + 1
        secondNumber = arc4random_uniform(3) + 1
        while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
            firstNumber = arc4random_uniform(12) + 1
            secondNumber = arc4random_uniform(3) + 1
        }
        numberOneLabel.text = firstNumber.description
        numberTwoLabel.text = secondNumber.description
        answerLabel.text = "0"
        nightButton.isHidden = true
    }
    
    //MARK:- Keypad Actions
    
    /// Action that occurs when the zero button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressZeroButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 0)
    }
    
    /// Action that occurs when the one button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressOneButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 1)
    }
    
    /// Action that occurs when the two button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressTwoButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 2)
    }
    
    /// Action that occurs when the three button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressThreeButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 3)
    }
    
    /// Action that occurs when the four button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressFourButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 4)
    }
    
    /// Action that occurs when the five button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressFiveButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 5)
    }
    
    /// Action that occurs when the six button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressSixButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 6)
    }
    
    /// Action that occurs when the seven button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressSevenButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 7)
    }
    
    /// Action that occurs when the eight button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressEightButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 8)
    }
    
    /// Action that occurs when the nine button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressNineButton(_ sender: UIButton) {
        appendValueToAnswerLabel(value: 9)
    }
    
    /// Action that occurs when the clear button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressClearButton(_ sender: UIButton) {
        answerLabel.text = "0"
    }
    
    /// Action that occurs when the fight button is pressed
    ///
    /// - Parameter sender: the touch on the button
    @objc func userDidPressFightButton(_ sender: UIButton) {
        let answer = Int(answerLabel.text!);
        previousAnswer = answer!
        livesLabel.text = "x " + lives.description
        // Check to see if answer is right or wrong
        if answer! != (firstNumber * secondNumber) {
            playIncorrectSound()
            lives = lives - 1
            gameScene.incorrect(firstNumber: Int(firstNumber), secondNumber: Int(secondNumber))
            // Check to see if game over
            if lives == -1 {
                gameOver()
            } else {
                livesLabel.text = "x " + lives.description
                if score >= 25 && score < 50 {
                    firstNumber = arc4random_uniform(15) + 2
                    secondNumber = arc4random_uniform(5) + 2
                    while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                        firstNumber = arc4random_uniform(15) + 2
                        secondNumber = arc4random_uniform(5) + 2
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else if (score >= 50 && score < 75) {
                    firstNumber = arc4random_uniform(19) + 5
                    secondNumber = arc4random_uniform(12) + 5
                    while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                        firstNumber = arc4random_uniform(19) + 5
                        secondNumber = arc4random_uniform(12) + 5
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else if score >= 75 && score < 100 {
                    firstNumber = arc4random_uniform(25) + 7
                    secondNumber = arc4random_uniform(15) + 7
                    while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                        firstNumber = arc4random_uniform(25) + 7
                        secondNumber = arc4random_uniform(15) + 7
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else if score >= 100 {
                    firstNumber = arc4random_uniform(25) + 10
                    secondNumber = arc4random_uniform(25) + 10
                    while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                        firstNumber = arc4random_uniform(25) + 10
                        secondNumber = arc4random_uniform(25) + 10
                    }
                    numberOneLabel.text = firstNumber.description
                    numberTwoLabel.text = secondNumber.description
                    answerLabel.text = "0"
                    scoreLabel.text = score.description
                } else {
                    firstNumber = arc4random_uniform(12) + 1
                    secondNumber = arc4random_uniform(3) + 1
                    while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
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
            gameScene.correct(score: score, nightCount: nightPressed)
            reportScoreToGC()
            //Check for Score Achievements
            if score >= 25 && score < 50 {
                if score == 25 {
                    let achievement = GKAchievement(identifier: "10p")
                    achievement.percentComplete = Double(score / 10)
                    achievement.showsCompletionBanner = true  // use Game Center's UI
                    GKAchievement.report([achievement], withCompletionHandler: nil)
                }
                firstNumber = arc4random_uniform(15) + 2
                secondNumber = arc4random_uniform(5) + 2
                while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                    firstNumber = arc4random_uniform(15) + 2
                    secondNumber = arc4random_uniform(5) + 2
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else if (score >= 50 && score < 75) {
                if score == 50 {
                    let achievement = GKAchievement(identifier: "25p")
                    achievement.percentComplete = Double(score / 25)
                    achievement.showsCompletionBanner = true  // use Game Center's UI
                    GKAchievement.report([achievement], withCompletionHandler: nil)
                }
                firstNumber = arc4random_uniform(19) + 5
                secondNumber = arc4random_uniform(12) + 5
                while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                    firstNumber = arc4random_uniform(19) + 5
                    secondNumber = arc4random_uniform(12) + 5
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else if score >= 75 && score < 100 {
                if score == 75 {
                    let achievement = GKAchievement(identifier: "50p")
                    achievement.percentComplete = Double(score / 30)
                    achievement.showsCompletionBanner = true  // use Game Center's UI
                    GKAchievement.report([achievement], withCompletionHandler: nil)
                }
                firstNumber = arc4random_uniform(25) + 7
                secondNumber = arc4random_uniform(15) + 7
                while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                    firstNumber = arc4random_uniform(25) + 7
                    secondNumber = arc4random_uniform(15) + 7
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else if score >= 100 {
                if score == 100 {
                    let achievement = GKAchievement(identifier: "75p")
                    achievement.percentComplete = Double(score / 60)
                    achievement.showsCompletionBanner = true  // use Game Center's UI
                    GKAchievement.report([achievement], withCompletionHandler: nil)
                }
                firstNumber = arc4random_uniform(25) + 10
                secondNumber = arc4random_uniform(25) + 10
                while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
                    firstNumber = arc4random_uniform(25) + 10
                    secondNumber = arc4random_uniform(25) + 10
                }
                numberOneLabel.text = firstNumber.description
                numberTwoLabel.text = secondNumber.description
                answerLabel.text = "0"
                scoreLabel.text = score.description
            } else {
                firstNumber = arc4random_uniform(12) + 1
                secondNumber = arc4random_uniform(3) + 1
                while(firstNumber < secondNumber || previousAnswer == (firstNumber * secondNumber)) {
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
    
    //MARK: Helper Methods
    
    /// This method determines the which mode the game is in day or night
    func nightHandle() {
        gameScene.skyCheck(nightCount: nightPressed)
        // Night Mode Enabled
        if (nightPressed % 2) == 0 {
            //Checks for achievements
            if nightPressed == 2 {
                let achievement = GKAchievement(identifier: "darkness")
                achievement.percentComplete = Double(score / 5)
                achievement.showsCompletionBanner = true  // use Game Center's UI
                GKAchievement.report([achievement], withCompletionHandler: nil)
            } else if nightPressed == 50 {
                let achievement = GKAchievement(identifier: "darknessMax")
                achievement.percentComplete = Double(score / 25)
                achievement.showsCompletionBanner = true  // use Game Center's UI
                GKAchievement.report([achievement], withCompletionHandler: nil)
            }
            nightButton.setTitle("☀️ Mode", for: .normal)
            view.backgroundColor = .black
            skView.layer.shadowColor = UIColor.white.cgColor
            skView.layer.borderColor = UIColor.white.cgColor
            highscoreLabel.textColor = .white
            highscoreTextLabel.textColor = .white
            scoreLabel.textColor = .white
            scoreTextLabel.textColor = .white
            livesLabel.textColor = .white
            numberOneLabel.textColor = .white
            numberTwoLabel.textColor = .white
            multiplyLabel.textColor = .white
            equalLabel.textColor = .white
            answerLabel.backgroundColor = .orange
            answerLabel.textColor = .white
            answerLabel.layer.shadowColor = UIColor.white.cgColor
            answerLabel.layer.borderColor = UIColor.white.cgColor
            pauseButton.setTitleColor(.white, for: .normal)
            for button in allButtons {
                button.layer.shadowColor = UIColor.white.cgColor
                button.layer.borderColor = UIColor.white.cgColor
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(.black, for: .highlighted)
                button.backgroundColor = .blue
            }
            
        } else { // Night Mode Disabled
            nightButton.setTitle("🌙 Mode", for: .normal)
            if nightPressed == 1 {
                let achievement = GKAchievement(identifier: "darkness")
                achievement.percentComplete = Double(score / 5)
                achievement.showsCompletionBanner = true  // use Game Center's UI
                GKAchievement.report([achievement], withCompletionHandler: nil)
            } else if nightPressed == 49 {
                let achievement = GKAchievement(identifier: "darknessMax")
                achievement.percentComplete = Double(score / 25)
                achievement.showsCompletionBanner = true  // use Game Center's UI
                GKAchievement.report([achievement], withCompletionHandler: nil)
            }
            view.backgroundColor = .white
            skView.layer.shadowColor = UIColor.black.cgColor
            skView.layer.borderColor = UIColor.black.cgColor
            for button in allButtons {
                button.layer.shadowColor = UIColor.black.cgColor
                button.layer.borderColor = UIColor.black.cgColor
                button.setTitleColor(.black, for: .normal)
                button.setTitleColor(.white, for: .highlighted)
                button.backgroundColor = #colorLiteral(red: 0.4751850367, green: 0.8376534581, blue: 0.9758662581, alpha: 1)
            }
            pauseButton.setTitleColor(.black, for: .normal)
            answerLabel.layer.shadowColor = UIColor.black.cgColor
            answerLabel.layer.borderColor = UIColor.black.cgColor
            highscoreLabel.textColor = .black
            highscoreTextLabel.textColor = .black
            scoreLabel.textColor = .black
            scoreTextLabel.textColor = .black
            livesLabel.textColor = .black
            numberOneLabel.textColor = .black
            numberTwoLabel.textColor = .black
            multiplyLabel.textColor = .black
            equalLabel.textColor = .black
            answerLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            answerLabel.textColor = .black
        }
    }
    /**
     
 */
    /// This method determines if the game is muted
    func muteHandle() {
        // Game is muted
        if (muteCount % 2) == 0 {
            isMute = true
            muteButton.setTitle("Unmute", for: .normal)
            bgAudioPlayer?.pause()
            audioPlayer?.stop()
        } else { // Game is unmuted
            isMute = false
            muteButton.setTitle("Mute", for: .normal)
            bgAudioPlayer?.prepareToPlay()
            bgAudioPlayer?.play()
            audioPlayer?.play()
            playBackSound()
        }
    }
    
    /// Function adds a value to the answer label
    ///
    /// - Parameter value: The value to add to the label
    func appendValueToAnswerLabel(value: Int) {
        guard let text = answerLabel.text, let number = Int("\(text)\(value)") else {
            print("An error occurred while updating the answerLabel.")
            return
        }
        answerLabel.text = "\(number)"
    }
    
    /// Hides the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /// The function ends the game and displays an ad
    func gameOver() {
        gameScene.gameOver()
        reportScoreToGC()
        checkLeaderboardButton.isHidden = false
        if score > highscore {
            highscore = score
            highscoreLabel.text = "\(highscore)"
            let highscoreDefaults = UserDefaults.standard
            highscoreDefaults.set(highscore, forKey: "highscore")
            highscoreDefaults.synchronize()
        }
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        livesLabel.isHidden = true
        livesImageView.isHidden = true
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
    
    /// Function hides the buttons for the start menu and when the game is paused
    func hideEverything() {
        pauseButton.isHidden = true
        numberOneLabel.isHidden = true
        numberTwoLabel.isHidden = true
        multiplyLabel.isHidden = true
        equalLabel.isHidden = true
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
        previousAnswer = 0
    }
    
    /// Function unhides the buttons for when the game begins and when the game is unpaused
    func showEverything() {
        pauseButton.isHidden = false
        numberOneLabel.isHidden = false
        numberTwoLabel.isHidden = false
        multiplyLabel.isHidden = false
        equalLabel.isHidden = false
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
        if !isMute {
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
    }
    
    func playIncorrectSound() {
        if !isMute {
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
    
    /// Method displays banner ad to the view when it loads
    ///
    /// - Parameter bannerView: the banner ad to display
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
    
    /// Method checks to see if a banner ad recieved an ad
    ///
    /// - Parameter bannerView: the banner ad to display
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        adBannerView = bannerView
    }
    
    /// Method checks to see if a banner ad failed to recieve an ad
    ///
    /// - Parameters:
    ///   - bannerView: The banner ad that failed to display
    ///   - error: Error that prints on fail
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
    
    
    /// Method gets an ad and puts it into an interstitial ad
    ///
    /// - Returns: the newly filled interstitial ad
    func createAndLoadInterstitial() -> GADInterstitial {
        //Real
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6279961815562254/6233439273")
        //Testing w/ Video
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/5135589807")
        //Testing w/ Static
        //interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self as? GADInterstitialDelegate
        let request = GADRequest()
        interstitial.load(request)
        return interstitial
    }
    
    /// Method reloads another ad in the background upon dismissing the interstitial ad
    ///
    /// - Parameter ad: the ad to dismiss
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    //MARK:- GameCenter Methods
    
    /// Dismisses the Game Center Leaderboard
    ///
    /// - Parameter gameCenterViewController: The gameCenterViewController to be dismissed
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    /// Function authenticates the player with Game Center
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error!)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }
    
    /// Method reports highscore to gamecenter
    func reportScoreToGC() {
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        //Report To GameCenter
        bestScoreInt.value = Int64(score)
        let currentGCScore = bestScoreInt.value
        if (currentGCScore <= highscore) {
            bestScoreInt.value = Int64(highscore)
            GKScore.report([bestScoreInt]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("Best Score submitted to your Leaderboard!")
                }
            }
        }
    }
    
    //MARK:- View Life-cycle
    
    /// Function that is used upon the initial loading of the App
    override func viewDidLoad() {
        super.viewDidLoad()
        allButtons = [startButton, checkLeaderboardButton, nightButton, muteButton, zeroButton, oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton, fightButton, clearButton, muteButton, playAgainButton]
        // Load Ads
        adBannerView.load(GADRequest())
        interstitial = createAndLoadInterstitial()
        // Authenticate player for Game Center
        authenticateLocalPlayer()
        let muteDefaults = UserDefaults.standard
        if muteDefaults.value(forKey: "mutePressed") != nil {
            muteCount = muteDefaults.value(forKey: "mutePressed") as! Int
            muteHandle()
        } else {
            muteHandle()
        }
        let nightDefaults = UserDefaults.standard
        if nightDefaults.value(forKey: "nightPressed") != nil {
            nightPressed = nightDefaults.value(forKey: "nightPressed") as! Int
            gameScene.skyCheck(nightCount: nightPressed)
            nightHandle()
        } else {
            gameScene.skyCheck(nightCount: nightPressed)
            nightHandle()
        }
        let startDefaults = UserDefaults.standard
        if startDefaults.value(forKey: "startPressed") != nil {
            startPressed = startDefaults.value(forKey: "startPressed") as! Int
        }
        let highscoreDefaults = UserDefaults.standard
        if highscoreDefaults.value(forKey: "highscore") != nil {
            highscore = highscoreDefaults.value(forKey: "highscore") as! Int
            highscoreLabel.text = "\(highscore)"
        }
        hideEverything()
        startButton.isHidden = false
        // Layout for the app
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
        view.addSubview(skView)
        
        let multiplicationStackView = UIStackView()
        multiplicationStackView.translatesAutoresizingMaskIntoConstraints = false
        multiplicationStackView.axis = .vertical
        multiplicationStackView.spacing = 10
        multiplicationStackView.alignment = .fill
        multiplicationStackView.distribution = .fill
        multiplicationStackView.addArrangedSubview(highscoreTextLabel)
        multiplicationStackView.addArrangedSubview(highscoreLabel)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(numberOneLabel)
        stackView.addArrangedSubview(multiplyLabel)
        stackView.addArrangedSubview(numberTwoLabel)
        stackView.addArrangedSubview(equalLabel)
        //stackView.addArrangedSubview(answerLabel)
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
        verticalButtonStackView.addArrangedSubview(checkLeaderboardButton)
        verticalButtonStackView.addArrangedSubview(nightButton)
        verticalButtonStackView.addArrangedSubview(muteButton)
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
        // Layout skView with our game scene.
        constraints.append(skView.topAnchor.constraintEqualToSystemSpacingBelow(headerStackView.bottomAnchor, multiplier: 1.0))
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
