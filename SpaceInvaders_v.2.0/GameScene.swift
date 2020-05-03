//
//  GameScene.swift
//  SpaceInvaders_v.2.0
//
//  Created by Iman Kefayati on 28.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        // die Szene Gamelevel1 und mit einem Effekt anzeigen
        self.view?.presentScene(GameLevel1(size: self.size), transition: SKTransition.flipHorizontal(withDuration: 1.0))

    }
    
    override func keyDown(with event: NSEvent) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
