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
    
    var graphicPath : [[SKSpriteNode]] = []
    
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
    
    

}
