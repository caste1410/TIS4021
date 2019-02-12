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
    
    var anuncio : SKLabelNode!
    var starBackground:SKEmitterNode!
    var path = [[ 0, 0,-1, 0, 0, 1],
                [-1, 0, 0, 0, 0, 0],
                [ 0,-1, 0, 0,-1,-1],
                [ 0, 0, 0, 0, 0, 0],
                [ 0, 0,-1, 0,-1, 0],
                [ 0, 0, 0, 0,-1, 0],
                [ 0, 0, 0,-1, 0, 0]]
    
    //Propiedades del algoritmo
    var gamma : Float!
    var r : [[Int]]!
    var q : [[Int]]!
    var final_state : Int!
    
    let tapRec = UITapGestureRecognizer()
    
    func setGesture() {
        tapRec.addTarget(self, action: #selector(GameScene.startLearning))
        tapRec.numberOfTouchesRequired = 1
        tapRec.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapRec)
    }
    
    @objc func startLearning() {
        if anuncio.text == "Tap para aprender"{
            anuncio.text = "Iniciando"
            qLearning()
            
        }else if anuncio.text == "Terminado"{
//Aqui iria lo que inicie el recorrido cool
        }
        
    }
    func setStart(point: [Int]) -> [Int]{
        var startPoint = point
        var randomRow = randomInt(path.count)
        var randomColumn = randomInt(path[0].count)
        
        if path[point[0]][point[1]] == 0{
            path[point[0]][point[1]] = 2
        }else{
            while path[randomRow][randomColumn] != 0{
                randomRow = randomInt(path.count)
                randomColumn = randomInt(path[0].count)
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
    
    func displayGP(board: [[Int]], current_pos : [Int]){
        var path = board
        path[current_pos[0]][current_pos[1]] = 2
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
        //setStart(point: [randomInt(path.count), randomInt(path[0].count)])
        displayGP(board: path, current_pos: setStart(point: [randomInt(path.count), randomInt(path[0].count)]))
        setGesture()
        starBackground = SKEmitterNode(fileNamed: "Stars")
        starBackground.position = CGPoint(x: 0, y: 0)
        starBackground.advanceSimulationTime(10)
        starBackground.zPosition = -1
        self.addChild(starBackground)
        
        anuncio = SKLabelNode(text: "Tap para aprender")
        anuncio.position.x = 0
        anuncio.position.y = -350
        anuncio.fontName = "Chalkboard"
        addChild(anuncio)
    }
    
    
    /* De aqui en adelante se implementa el algoritmo */
    
    func qLearning() {
        stepOne_Two(g: 0.8, rewards: rewardMatrix())
        stepThree(episodes: 1)
    }
    
    func  stepOne_Two(g : Float, rewards: [[Int]])  {
        final_state = 5
        // Valor Gamma
        gamma = g
        // Matrix de recompenzas
        r = rewards
        // Matriz de aprendizaje
        q = init_q()
        
    }
    
    func stepThree(episodes: Int) {
        for _ in 0 ..< episodes {
            var init_pos = setStart(point: [randomInt(path.count), randomInt(path[0].count)])
            //var current_state = path
            var current_state = 6 * init_pos[0] + init_pos[1]
            //current_state[current_pos[0]][current_pos[1]] = 2
            
            repeat {
                displayGP(board: path, current_pos: [current_state/path[0].count, current_state%path[0].count])
                // Select one among all possible actions for the current state.
                let possible_actions = getAllPosibleActions(state: current_state)
                let next_state = selectOneOption(actions: possible_actions)
                // Using this possible action, consider going to the next state.
                let next_possible_actions = getAllPosibleActions(state: next_state)
                // Get maximum Q value for this next state based on all possible actions.
                let maxQ = Float(Max(actions: next_possible_actions))
                // Compute: Q(state, action) = R(state, action) + Gamma * Max[Q(next state, all actions)]
                let reward = r[current_state][next_state]
                q[current_state][next_state] = reward + Int(gamma * maxQ)
                // Set the next state as the current state.
                current_state = next_state
                
                
            } while (current_state != final_state)
            
            
        }
        
    }
    
    func randomInt(_ max: Int) -> Int {
        return Int.random(in: 0..<max)
    }
    func getAllPosibleActions(state: Int) -> [[Int]]{
        //var possible_actions : [[Int]]!
        var j = 0
        /*possible_actions
        /for j in 0 ..< r[0].count {
            if r[state][j] >= 0 {
                possible_actions.append([state, j, r[state][j]])
            }
        }*/
        return r[state].map {let triplet = [state, j, $0]; j += 1; return triplet}
        //return possible_actions//.filter {$0[2] == max}
        
    }
    func selectOneOption(actions: [[Int]]) -> Int {
        // Obtener el maximo reward
        let max = actions.map {$0[2]}.max()!
        // Obtencion de opciones con mayor reward
        let options = actions.filter {$0[2] == max}.map {$0[1]}
        // Regresa un elemento al azhar
        return options.randomElement()!
    }
    func Max(actions: [[Int]]) -> Int {
        // Regresa el maximo valor de refuerzo entre las acciones
        return actions.map { q[$0[0]][$0[1]]} .max()!
    }
    
    func rewardMatrix() -> [[Int]] {
        var matrix = [[Int]]()
        
        for _ in 0..<(path.count * path[0].count) {
            matrix.append([Int](repeating: -1, count: (path.count * path[0].count)))
        }
        // 0
        matrix[0][1] = 0
        // 1
        matrix[1][0] = 0
        matrix[1][7] = 0
        // 3
        matrix[3][4] = 0
        matrix[3][9] = 0
        // 4
        matrix[4][3] = 0
        matrix[4][5] = 100
        matrix[4][10] = 0
        // 5
        matrix[5][4] = 0
        matrix[5][5] = 100
        matrix[5][11] = 0
        // 7
        matrix[7][1] = 0
        matrix[7][8] = 0
        // 8
        matrix[8][7] = 0
        matrix[8][9] = 0
        matrix[8][14] = 0
        // 9
        matrix[9][3] = 0
        matrix[9][8] = 0
        matrix[9][10] = 0
        matrix[9][15] = 0
        // 10
        matrix[10][4] = 0
        matrix[10][9] = 0
        matrix[10][11] = 0
        // 11
        matrix[11][5] = 100
        matrix[11][10] = 0
        // 12
        matrix[12][18] = 0
        // 14
        matrix[14][8] = 0
        matrix[14][15] = 0
        matrix[14][20] = 0
        // 15
        matrix[15][9] = 0
        matrix[15][14] = 0
        matrix[15][21] = 0
        // 18
        matrix[18][12] = 0
        matrix[18][19] = 0
        matrix[18][24] = 0
        // 19
        matrix[19][18] = 0
        matrix[19][20] = 0
        matrix[19][25] = 0
        // 20
        matrix[20][14] = 0
        matrix[20][19] = 0
        matrix[20][21] = 0
        // 21
        matrix[21][15] = 0
        matrix[21][20] = 0
        matrix[21][22] = 0
        matrix[21][27] = 0
        // 22
        matrix[22][21] = 0
        matrix[22][23] = 0
        // 23
        matrix[23][22] = 0
        matrix[23][29] = 0
        // 24
        matrix[24][18] = 0
        matrix[24][25] = 0
        matrix[24][30] = 0
        // 25
        matrix[25][19] = 0
        matrix[25][24] = 0
        matrix[25][31] = 0
        // 27
        matrix[27][21] = 0
        matrix[27][33] = 0
        // 29
        matrix[29][23] = 0
        matrix[29][35] = 0
        // 30
        matrix[30][24] = 0
        matrix[30][31] = 0
        matrix[30][36] = 0
        // 31
        matrix[31][25] = 0
        matrix[31][30] = 0
        matrix[31][32] = 0
        matrix[31][37] = 0
        // 32
        matrix[32][31] = 0
        matrix[32][33] = 0
        matrix[32][38] = 0
        // 33
        matrix[33][27] = 0
        matrix[33][32] = 0
        // 35
        matrix[35][29] = 0
        matrix[35][41] = 0
        // 36
        matrix[36][30] = 0
        matrix[36][37] = 0
        // 37
        matrix[37][31] = 0
        matrix[37][36] = 0
        matrix[37][38] = 0
        // 38
        matrix[38][32] = 0
        matrix[38][37] = 0
        // 40
        matrix[40][41] = 0
        // 41
        matrix[41][40] = 0
        matrix[41][35] = 0
        
        return matrix
    }
    
    func init_q() -> [[Int]] {
        var matrix = [[Int]]()
        
        for _ in 0..<(path.count * path[0].count) {
            matrix.append([Int](repeating: 0, count: (path.count * path[0].count)))
        }
        return matrix
    }
}
