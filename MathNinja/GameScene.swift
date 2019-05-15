//
//  GameScene.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import SpriteKit

/// This Class Represents the GameScene for the Sprites
class GameScene: SKScene {
    
    /// The Good Guy in the GameScene
    var player: SKSpriteNode = SKSpriteNode()
    
    /// The Bad Guy in the GameScene
    var enemy: SKSpriteNode = SKSpriteNode()
    
    /// The SK Label Node to display the correct answer or positive phrases
    var tauntLabel: SKLabelNode = SKLabelNode()
    
    /// The SK Label Node that displays Game Over at Game Over
    var gameOverLabel: SKLabelNode = SKLabelNode()
    
    /// The Good Guy's projectile that he fires on correct answers
    var weapon: SKSpriteNode = SKSpriteNode()
    
    /// The Bad Guy's projectile that he fires on correct answers
    var enemyFire: SKSpriteNode = SKSpriteNode()
    
    /// The daytime sky that displays during day mode
    var daySky: SKSpriteNode = SKSpriteNode()
    
    /// The daytime floor that displays during day mode
    var dayFloor: SKSpriteNode = SKSpriteNode()
    
    /// The night time sky that displays during night mode
    var nightSky: SKSpriteNode = SKSpriteNode()
    
    /// The night time floor that displays during night mode
    var nightFloor: SKSpriteNode = SKSpriteNode()
    
    /// The Array of positive affirmations to display on correct
    let happyArray = ["Great Job!","Keep it Up!", "Nice!", "Take That!", "WOOHOO!", "Math Punch!", "Bam!", "Pow!", "Awesome!"]
    
    
    /// Called after the view controller is added or removed from a
    /// container view controller.
    ///
    /// - Parameter view: The view
    override func didMove(to view: SKView) {
        ///: Initializing the Nodes
        if let somePlayer: SKSpriteNode = self.childNode(withName: "Player") as? SKSpriteNode {
            player = somePlayer
            player.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someEnemy: SKSpriteNode = self.childNode(withName: "Enemy") as? SKSpriteNode {
            enemy = someEnemy
            enemy.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someTaunt: SKLabelNode = self.childNode(withName: "WordLabel") as? SKLabelNode {
            tauntLabel = someTaunt
            tauntLabel.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someGameOver: SKLabelNode = self.childNode(withName: "GameOver") as? SKLabelNode {
            gameOverLabel = someGameOver
            gameOverLabel.isHidden = true
            gameOverLabel.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someWeapon: SKSpriteNode = self.childNode(withName: "Weapon") as? SKSpriteNode {
            weapon = someWeapon
            weapon.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someEnemyFire: SKSpriteNode = self.childNode(withName: "Fire") as? SKSpriteNode {
            enemyFire = someEnemyFire
            enemyFire.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someSky: SKSpriteNode = self.childNode(withName: "Sky") as? SKSpriteNode {
            daySky = someSky
            daySky.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someNightSky: SKSpriteNode = self.childNode(withName: "Night") as? SKSpriteNode {
            nightSky = someNightSky
            nightSky.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someNightFloor: SKSpriteNode = self.childNode(withName: "Night Floor") as? SKSpriteNode {
            nightFloor = someNightFloor
            nightFloor.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
        if let someDayFloor: SKSpriteNode = self.childNode(withName: "Day Floor") as? SKSpriteNode {
            dayFloor = someDayFloor
            dayFloor.physicsBody?.isDynamic = false
        } else {
            print("failed!")
        }
    }
    
    /// This method will be called by the GameViewController, when a question
    /// is answered incorrectly.
    ///
    /// - Parameters:
    ///   - firstNumber: The first number to be passed into the equation
    ///   - secondNumber: The second number to be passed into the equation
    public func incorrect(firstNumber: Int, secondNumber: Int) {
        fireEnemyWeapon()
        tauntLabel.isHidden = false
        gameOverLabel.isHidden = true
        tauntLabel.text = solveEquation(firstNumber: firstNumber, secondNumber: secondNumber)
        tauntLabel.fontColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
        let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
        let seq = SKAction.sequence([comeIn, goAway])
        tauntLabel.run(seq)
    }
    
    /// This method will be called by the GameViewController, when a question
    /// is answered correctly.
    ///
    /// - Parameters:
    ///   - score: The current score which is needed for accurate message displaying
    ///   - nightCount: The nightCount in order to determine, which mode is enabled
    public func correct(score: Int, nightCount: Int) {
        skyCheck(nightCount: nightCount)
        fireWeapon()
        tauntLabel.isHidden = false
        gameOverLabel.isHidden = true
        ///: Determining what message to display based off the score
        if score == 25 {
            tauntLabel.text = "Now to Medium Mode!"
            tauntLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tauntLabel.run(SKAction.fadeIn(withDuration: 1.0))
            tauntLabel.run(SKAction(named: "Special")!)
            tauntLabel.run(SKAction.fadeIn(withDuration: 2.0))
        } else if score > 25 && score < 50 {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        } else if score == 50 {
            tauntLabel.text = "Now to Hard Mode!"
            tauntLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tauntLabel.run(SKAction.fadeIn(withDuration: 1.0))
            tauntLabel.run(SKAction(named: "Special")!)
            tauntLabel.run(SKAction.fadeIn(withDuration: 2.0))
        } else if score > 50 && score < 75 {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        } else if score == 75 {
            tauntLabel.text = "Now to Extreme Mode!"
            tauntLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tauntLabel.run(SKAction.fadeIn(withDuration: 1.0))
            tauntLabel.run(SKAction(named: "Special")!)
            tauntLabel.run(SKAction.fadeIn(withDuration: 2.0))
        } else if score > 75 && score < 100 {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        } else if score == 100 {
            tauntLabel.text = "Now to 🤯 Mode!"
            tauntLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tauntLabel.run(SKAction.fadeIn(withDuration: 1.0))
            tauntLabel.run(SKAction(named: "Special")!)
            tauntLabel.run(SKAction.fadeIn(withDuration: 2.0))
        } else if score > 100 {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        } else {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        }
    }
    
    /// Method to fire Good Guy's Projectile at Bad Guy
    func fireWeapon() {
        let playerAttackSequence = SKAction.run {
            self.player.run(SKAction(named: "playerAttack")!)
            self.enemy.run(SKAction(named: "enemyHit")!)
        }
        player.run(SKAction.sequence([playerAttackSequence]))
    }
    
    public func resetNodeLocations() {
        player.run(SKAction.moveTo(x: -211.888, duration: 0.25))
        enemy.run(SKAction.moveTo(x: 226.802, duration: 0.25))
    }
    /// Method to fire Bad Guy's Projectile at Good Guy
    func fireEnemyWeapon() {
        let enemyAttackSequence = SKAction.run {
            self.enemy.run(SKAction(named: "enemyAttack")!)
            self.player.run(SKAction(named: "playerHit")!)
        }
        enemy.run(enemyAttackSequence)
    }
    
    /// This method is called to check the game mode in regards to day/night
    ///
    /// - Parameter nightCount: The nightCount in order to determine, which mode is enabled
    public func skyCheck(nightCount: Int) {
        if (nightCount % 2) == 0 {
            tauntLabel.fontColor = #colorLiteral(red: 0.7490196078, green: 0.3529411765, blue: 0.9490196078, alpha: 1)
            daySky.run(SKAction.hide())
            dayFloor.run(SKAction.hide())
            nightSky.run(SKAction.unhide())
            nightFloor.run(SKAction.unhide())
        } else {
            tauntLabel.fontColor = .blue
            nightSky.run(SKAction.hide())
            nightFloor.run(SKAction.hide())
            daySky.run(SKAction.unhide())
            dayFloor.run(SKAction.unhide())            
        }
    }
    
    /// Method is called to reset nodes back to their original states.
    public func playedAgain() {
        resetNodeLocations()
        tauntLabel.isHidden = false
        gameOverLabel.isHidden = true
        player.run(SKAction(named: "live")!)
    }
    
    /// Method is called to display the game over message and fade the enemy out.
    public func gameOver() {
        tauntLabel.isHidden = true
        gameOverLabel.isHidden = false
        gameOverLabel.run(SKAction(named: "Special")!)
        enemy.run(SKAction(named: "Special")!)
        player.run(SKAction(named: "death")!)
    }
    
    /// Helper Method to get the message to display for incorrect question
    ///
    /// - Parameters:
    ///   - firstNumber: The first number to multiply
    ///   - secondNumber: The second number to multiply
    /// - Returns: The string representation of the equation with the correct answer
    func solveEquation(firstNumber: Int, secondNumber: Int) -> String {
        return "\(firstNumber) x \(secondNumber) = \(firstNumber * secondNumber)"
    }
}
