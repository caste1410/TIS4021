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
                    block = SKSpriteNode(imageNamed: "ficha")
                    row.append(block)
                case 1:
                    block = SKSpriteNode(imageNamed: "fichaM")
                    row.append(block)
                case 2:
                    block = SKSpriteNode(imageNamed: "fichaV")
                    row.append(block)
                default:
                    block = SKSpriteNode(imageNamed: "fichaA")
                    row.append(block)
                }
            }
            graphicPath.append(row)
        }
        
        return graphicPath.reversed()
    }
    
    func displayGP(){
        
        let graphicPath = makeGraphicPath(path: path)
        let size = CGSize(width: 66, height: 77)
        
        for i in graphicPath{
            var col = 0
            for j in i{
                j.position.y = self.size.height/2
                j.zPosition = 0
                j.size = size
                j.physicsBody = SKPhysicsBody(rectangleOf: size)
                j.physicsBody?.affectedByGravity = true
                j.physicsBody?.allowsRotation = false
                switch col{
                case 0:
                    j.position.x = self.size.width/(-2.45)
                    col += 1
                    addChild(j)
                case 1:
                    j.position.x = self.size.width/(-4)
                    col += 1
//                    addChild(j)
                case 2:
                    j.position.x = self.size.width/(-11.6)
                    col += 1
//                    addChild(j)
                case 3:
                    j.position.x = self.size.width/11.6
                    col += 1
//                    addChild(j)
                case 4:
                    j.position.x = self.size.width/4
                    col += 1
//                    addChild(j)
                default:
                    j.position.x = self.size.width/2.45
                    col += 1
//                    addChild(j)
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        setStart(point: [0,0])
        displayGP()
    }

}
