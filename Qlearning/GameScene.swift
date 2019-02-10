//
//  GameScene.swift
//  Qlearning
//
//  Created by Carlos Castelán Vázquez on 2/9/19.
//  Copyright © 2019 Carlos Castelán Vázquez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var starBackground:SKEmitterNode!
    var path = [[0,0,-1,0,0,1],
                [-1,0,0,0,0,0],
                [0,-1,0,0,-1,-1],
                [0,0,0,0,0,0],
                [0,0,-1,0,0,-1],
                [0,0,0,0,-1,0],
                [0,0,0,-1,0,0]]
    
    
    func setStart(point: [Int]) -> [Int]{
        var startPoint = point
        var randomRow = Int.random(in: 0..<6)
        var randomColumn = Int.random(in: 0..<7)
        
        if path[point[0]][point[1]] == 0{
            path[point[0]][point[1]] = 2
        }else{
            while path[randomRow][randomColumn] != 0{
                randomRow = Int.random(in: 0..<6)
                randomColumn = Int.random(in: 0..<7)
            }
            path[randomRow][randomColumn] = 2
            startPoint = [randomRow,randomColumn]
        }
        return startPoint
    }
    
    func makeGraphicPath(path: [[Int]]) -> [[SKSpriteNode]]{
        var graphicPath : [[SKSpriteNode]] = []
        
        for i in path{
            var row : [SKSpriteNode] = []
            
            for j in i{
                var block : SKSpriteNode
                switch j{
                case -1:
                    block = SKSpriteNode(imageNamed: "alien")
                    row.append(block)
                case 1:
                    block = SKSpriteNode(imageNamed: "heart")
                    row.append(block)
                case 2:
                    block = SKSpriteNode(imageNamed: "nave")
                    row.append(block)
                default:
                    block = SKSpriteNode(imageNamed: "libre")
                    block.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                    row.append(block)
                }
            }
            graphicPath.append(row)
        }
        
        return graphicPath.reversed()
    }
    
    func diplayRow(row: [SKSpriteNode], yPosition: Float ){
        
        let size = CGSize(width: 66, height: 66)
        
        for i in 0...row.count-1{
            row[i].position.y = CGFloat(yPosition)
            row[i].zPosition = 0
            row[i].size = size
            row[i].physicsBody = SKPhysicsBody(rectangleOf: size)
            row[i].physicsBody?.affectedByGravity = true
            row[i].physicsBody?.allowsRotation = false
            
            switch i{
            case 0:
                row[i].position.x = self.size.width/(-2.45)
                addChild(row[i])
            case 1:
                row[i].position.x = self.size.width/(-4)
                addChild(row[i])
            case 2:
                row[i].position.x = self.size.width/(-11.6)
                addChild(row[i])
            case 3:
                row[i].position.x = self.size.width/11.6
                addChild(row[i])
            case 4:
                row[i].position.x = self.size.width/4
                addChild(row[i])
            default:
                row[i].position.x = self.size.width/2.45
                addChild(row[i])
            }
        }
        
    }
    
    func displayGP(){
        let graphicPath = makeGraphicPath(path: path)
        for i in 0...graphicPath.count-1{
            switch i{
            case 0:
                diplayRow(row: graphicPath[i], yPosition: -217.635)
            case 1:
                diplayRow(row: graphicPath[i], yPosition: -151.635)
            case 2:
                diplayRow(row: graphicPath[i], yPosition: -85.635)
            case 3:
                diplayRow(row: graphicPath[i], yPosition: -19.635)
            case 4:
                diplayRow(row: graphicPath[i], yPosition: 46.635)
            case 5:
                diplayRow(row: graphicPath[i], yPosition: 112.635)
            default:
                diplayRow(row: graphicPath[i], yPosition: 178.635)
            }
        }
    }
    
    override func didMove(to view: SKView) {
        setStart(point: [0,0])
        displayGP()
        
        starBackground = SKEmitterNode(fileNamed: "Stars")
        starBackground.position = CGPoint(x: 0, y: 0)
        starBackground.advanceSimulationTime(10)
        starBackground.zPosition = -1
        self.addChild(starBackground)
    }
    
}
