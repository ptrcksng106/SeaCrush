//
//  ContentView.swift
//  CrushChallenge
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 18/05/23.
//

import SwiftUI
import SpriteKit
import GameKit


class PuzzleCrush: SKScene {

    var cols = [[Item]]()
    let itemSize: CGFloat = 60
    var itemsPerColum = 10
    var itemsPerRow = 10
    var currentMatch = Set<Item>()
    let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    let highestScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    var isTouched: Bool = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    
    
    var highestScore = UserDefaults().integer(forKey: "highScore") {
        didSet {
            highestScoreLabel.text = "Highest Score : \(UserDefaults().integer(forKey: "highScore"))"
        }
    }
    
    let timerLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    var timer = 20 {
        didSet {
            timerLabel.text = "Time Left: \(timer)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: size.width, y: 550)
        background.setScale(1.7)
        background.alpha = 0.5
        addChild(background)
        
        scene?.size = CGSize(width: 750, height: 1200)
        
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 190, y: 920)
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
        
        timerLabel.position = CGPoint(x: 530, y: 970)
        timerLabel.zPosition = 10
        addChild(timerLabel)
        
        highestScoreLabel.position = CGPoint(x: 200, y: 970)
        highestScoreLabel.zPosition = 15
        addChild(highestScoreLabel)
        
        
        if action(forKey: "countdown") != nil {removeAction(forKey: "countdown")}
        
            let wait = SKAction.wait(forDuration: 0.8)
            let block = SKAction.run({
                
                if self.timer > 0 {
                    self.timer -= 1
                } else if self.timer == 0 {
                    self.gameOver()
                } else {
                    self.removeAction(forKey: "countdown")
                }

            })

            let sequence = SKAction.sequence([wait,block])
            

            run(SKAction.repeatForever(sequence), withKey: "countdown")
        
        
        
        
        score = 0
        timer = 20
        highestScore = UserDefaults().integer(forKey: "highScore")
        
        
        
        
        for x in 0..<itemsPerRow  {
            
            var col = [Item]()
            
            for y in 0..<itemsPerColum {
                let item = createItem(row: y, col: x)
                col.append(item)
            }
            
            cols.append(col)
        }
        
    }
    
    func positionItem (for item: Item) -> CGPoint {
        
        let xOffSet: CGFloat = 100
        let yOffSet: CGFloat = 300
        let x = xOffSet + itemSize * CGFloat(item.col)
        let y = yOffSet + itemSize * CGFloat(item.row)
        
        return CGPoint(x: x, y: y)
        
    }
    
    func createItem(row: Int, col: Int, startOffScreen: Bool = false) -> Item {
        
        let itemImage: String
        
        if startOffScreen && GKRandomSource.sharedRandom().nextInt(upperBound: 25) == 00 {
            itemImage = "trash_apple"
            
            
        } else {
            let itemImages = ["gambarSatu", "gambarDua", "gambarTiga", "gambarEmpat", "gambarLima"]
            itemImage = itemImages[GKRandomSource.sharedRandom().nextInt(upperBound: itemImages.count)]
            
        }
        
        let item = Item(imageNamed: itemImage)
        item.name = itemImage
        item.row = row
        item.col = col

        
        if startOffScreen {
            
            let finalPosition = positionItem(for: item)
            
            item.position = finalPosition
            item.position.y += 600
            
            let downAction = SKAction.move(to: finalPosition, duration: 0.3)
            item.run(downAction)
            self.isUserInteractionEnabled = true
            
            if timer <= 0 {
                gameOver()
                self.isUserInteractionEnabled = false
            } else {
                
            }
        } else {
            
            item.position = positionItem(for: item)
        }
        
        item.size = CGSize(width: itemSize, height: itemSize)
        item.alpha = 0.8
        addChild(item)
        
        return item
        
    }
    
    
    func findItem(point: CGPoint) -> Item? {
        let item = nodes(at: point).compactMap{$0 as? Item}
        
        return item.first
    }
    
    func findMatch(original: Item) {
        var checkItems = [Item?]()
        
        currentMatch.insert(original)
        let position = original.position
        
        checkItems.append(findItem(point: CGPoint(x: position.x, y: position.y - itemSize)))
        checkItems.append(findItem(point: CGPoint(x: position.x, y: position.y + itemSize)))
        checkItems.append(findItem(point: CGPoint(x: position.x - itemSize, y: position.y)))
        checkItems.append(findItem(point: CGPoint(x: position.x + itemSize, y: position.y)))
        
        for case let check? in checkItems {
            if currentMatch.contains(check) {
                continue
            }
            
            if check.name == original.name || original.name == "trash_apple" {
                findMatch(original: check)
            }
        }
        
    }
    
    func removeMatches() {
        
            let sortedMatches = currentMatch.sorted {
                $0.row > $1.row
            }
            
            for item in sortedMatches {
                cols[item.col].remove(at: item.row)
                
                item.removeFromParent()
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        
        guard let tappedItem = findItem(point: location) else {
            return
        }
        
       
        
        isUserInteractionEnabled = false
        
        currentMatch.removeAll()
        
        
        if tappedItem.name == "trash_apple" {
            specialItem(item: tappedItem)
        }
        
        findMatch(original: tappedItem)
        
        removeMatches()
        moveDown()
        makeScore()
        saveHighScore()
    }
    
    func saveHighScore() {
        
        if score > UserDefaults().integer(forKey: "highScore") {
            UserDefaults.standard.set(score, forKey: "highScore")
            highestScoreLabel.text = "Highest Score: \(UserDefaults().integer(forKey: "highScore"))"
        }
    }
    
    func moveDown() {
        
        for (columnIndex, col) in cols.enumerated() {
            
            for (rowIndex, item) in col.enumerated() {
                
                item.row = rowIndex
                
                let downAction = SKAction.move(to: positionItem(for: item), duration: 0.3)
                item.run(downAction)
            }
            while cols[columnIndex].count < itemsPerRow {
                let item = createItem(row: cols[columnIndex].count, col: columnIndex, startOffScreen: true)
                cols[columnIndex].append(item)
            }
        }
    }
    
    func specialItem(item: Item) {
        
        let smoked = SKEmitterNode(fileNamed: "exploTrash")
        
        smoked?.position = item.position
        smoked?.zPosition = 10
        addChild(smoked!)
        
        self.run(SKAction.wait(forDuration: 2)) {
            smoked?.removeFromParent()
        }
    }
    
    func makeScore() {
        let newScore = currentMatch.count
        
        if newScore == 1 {
            
//            gameOver()
           
            
        } else if newScore == 2 {
            let matchCount = min(newScore, 2)
            
            let scoreToAdd = pow(2, Double(matchCount))
            
            score += Int(scoreToAdd)
        } else {
            let matchCount = min(newScore, 6)
            
            let scoreToAdd = pow(2, Double(matchCount))
            
            score += Int(scoreToAdd)
        }
        
    }
    
    func gameOver() {
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOver.size = CGSize(width: 900, height: 1100)
        gameOver.zPosition = 20
        addChild(gameOver)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.view?.presentScene(PuzzleCrush(size: CGSize(width: 450, height: 1100)))
        }
    }
    
}

struct ContentView: View {
    
    var scene = PuzzleCrush()
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
