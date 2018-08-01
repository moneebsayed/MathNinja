//
//  GameScene.swift
//  MathNinja
//
//  Created by Moneeb Sayed on 3/31/18.
//  Copyright © 2018 Moneeb Sayed. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode = SKSpriteNode()
    
    var enemy: SKSpriteNode = SKSpriteNode()
    
    var tauntLabel: SKLabelNode = SKLabelNode()
    
    var gameOverLabel: SKLabelNode = SKLabelNode()
    
    var weapon: SKSpriteNode = SKSpriteNode()
    
    var enemyFire: SKSpriteNode = SKSpriteNode()
    
    var daySky: SKSpriteNode = SKSpriteNode()
    
    var nightSky: SKSpriteNode = SKSpriteNode()
    
    let happyArray = ["Great Job!","Keep it Up!", "Nice!", "Take That!", "WOOHOO!", "Math Punch!", "Bam!", "Pow!"]
    
    override func didMove(to view: SKView) {
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
    }
    
    public func correct(score: Int) {
        fireWeapon()
        tauntLabel.isHidden = false
        gameOverLabel.isHidden = true
        if score == 25 {
            tauntLabel.text = "Now to Medium Mode!"
            tauntLabel.fontColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            tauntLabel.run(SKAction.fadeIn(withDuration: 1.0))
            tauntLabel.run(SKAction(named: "Special")!)
            tauntLabel.run(SKAction.fadeIn(withDuration: 2.0))
        } else if score > 25 && score < 50 {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            tauntLabel.fontColor = .blue
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
            tauntLabel.fontColor = .blue
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
            tauntLabel.fontColor = .blue
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
            tauntLabel.fontColor = .blue
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        } else {
            tauntLabel.text = happyArray[Int(arc4random_uniform(6))]
            tauntLabel.fontColor = .blue
            let comeIn:SKAction = SKAction.fadeIn(withDuration: 1.0)
            let goAway:SKAction = SKAction.fadeOut(withDuration: 2.0)
            let seq = SKAction.sequence([comeIn, goAway])
            tauntLabel.run(seq)
        }
    }
    
    public func playedAgain() {
        tauntLabel.isHidden = false
        gameOverLabel.isHidden = true
        let fadeIn: SKAction = SKAction.fadeIn(withDuration: 0.1)
        let moveToBackX: SKAction = SKAction.moveTo(x: -205.158, duration: 0.25)
        let seq = SKAction.sequence([moveToBackX, fadeIn])
        player.run(seq)
    }
    
    public func gameOver() {
        tauntLabel.isHidden = true
        gameOverLabel.isHidden = false
        gameOverLabel.run(SKAction(named: "Special")!)
        enemy.run(SKAction(named: "Special")!)
        let moveOutsideX: SKAction = SKAction.moveTo(x: -500, duration: 0.1)
        let fadeOut: SKAction = SKAction.fadeOut(withDuration: 0.05)
        let seq = SKAction.sequence([moveOutsideX, fadeOut])
        player.run(seq)
    }
    
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
    
    func fireWeapon() {
        weapon.isHidden = false
        let fadeIn: SKAction = SKAction.fadeIn(withDuration: 0.1)
        let moveToOtherSideX: SKAction = SKAction.moveTo(x: 261, duration: 0.5)
        let moveToOtherSideY: SKAction = SKAction.moveTo(y: -30.05, duration: 0.5)
        let moveOutsideX: SKAction = SKAction.moveTo(x: 500, duration: 0.25)
        //Hit Bad Guy
        let rotateBadGuy: SKAction = SKAction.rotate(byAngle: 360, duration: 0.30)
        let rotateBack: SKAction = SKAction.rotate(toAngle: 0, duration: 0.25, shortestUnitArc: false)
        //let rotateBadGuyBack: SKAction = SKAction.rotate(toAngle: 369, duration: 1)
        //Reload
        let fadeOut: SKAction = SKAction.fadeOut(withDuration: 0.05)
        let moveToBackX: SKAction = SKAction.moveTo(x: -147.9, duration: 0.25)
        let moveToBackY: SKAction = SKAction.moveTo(y: -30.05, duration: 0.25)
        let seq = SKAction.sequence([fadeIn, moveOutsideX, moveToOtherSideY, fadeOut, moveToBackX, moveToBackY])
        //let seq2 = SKAction.sequence([fadeOut, moveToBackX, moveToBackY])
        let badSeq = SKAction.sequence([rotateBadGuy, rotateBack, moveToOtherSideX, moveToOtherSideY])
        weapon.run(seq)
        enemy.run(badSeq)
        //weapon.run(seq2)
    }
    
    func fireEnemyWeapon() {
        enemyFire.isHidden = false
        let fadeIn: SKAction = SKAction.fadeIn(withDuration: 0.1)
        let moveToOtherSideY: SKAction = SKAction.moveTo(y: -30.05, duration: 0.5)
        let moveOutsideX: SKAction = SKAction.moveTo(x: -500, duration: 0.25)
        //Hit Good Guy
        let rotateGoodGuy: SKAction = SKAction.rotate(byAngle: 360, duration: 0.30)
        let rotateBack: SKAction = SKAction.rotate(toAngle: 0, duration: 0.25, shortestUnitArc: false)
        //let rotateBadGuyBack: SKAction = SKAction.rotate(toAngle: 369, duration: 1)
        //Reload
        let fadeOut: SKAction = SKAction.fadeOut(withDuration: 0.05)
        let moveToBackX: SKAction = SKAction.moveTo(x: -205.158, duration: 0.25)
        //175.906
        let moveToWeapBackX: SKAction = SKAction.moveTo(x: 175.906, duration: 0.25)
        //let moveToBackY: SKAction = SKAction.moveTo(y: -30.05, duration: 0.25)
        let seq = SKAction.sequence([fadeIn, moveOutsideX, fadeOut, moveToWeapBackX, moveToOtherSideY])
        //let seq2 = SKAction.sequence([fadeOut, moveToBackX, moveToBackY])
        let goodSeq = SKAction.sequence([rotateGoodGuy, rotateBack, moveToBackX, moveToOtherSideY])
        enemyFire.run(seq)
        player.run(goodSeq)
        //weapon.run(seq2)
    }
    func solveEquation(firstNumber: Int, secondNumber: Int) -> String {
        return "\(firstNumber) x \(secondNumber) = \(firstNumber * secondNumber)"
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
