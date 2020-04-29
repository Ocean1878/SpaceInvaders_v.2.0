//
//  Raumschiff.swift
//  SpaceInvaders_v.2.0
//
//  Created by Iman Kefayati on 28.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import SpriteKit

class Raumschiff: SKSpriteNode {
    // für die Szene
    var szene: SKScene!
    
    // der Initialisierer erzeugt das Raumschiff
    init() {
        // das Bild erzeugen
        let bild = SKTexture(imageNamed: "verteidiger")
        // den Konstruktor der übergeordneten Klasse aufrufen
        super.init(texture: bild, color: NSColor.black, size: bild.size())
        
        
        // die Formen für die Kollisionsprüfung
        // hier ein Rechteck in der Größe des Sprites
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        
        // das Raumschiff bekommt die Kategorie 1 = 0b1
        // sie muss als Bitmaske als binärer Wert angegeben werden
        self.physicsBody?.categoryBitMask = 0b1
        
        // reagiert auf Kontakt mit einem Aliengeschoss
        // und das Alien
        self.physicsBody?.contactTestBitMask = 0b10 | 0b100
        
        // es soll aber nicht auf Kollisionen reagieren
        self.physicsBody?.collisionBitMask = 0
    }
    
    // der Initialisierer wird durch die Basisklasse erzwungen
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // die Methode setzt das Raumschiff in die übergebene Szene und
    // zeigt es an
    func setzePosition(szene: SKScene) {
        // die Szene speichern
        self.szene = szene
        
        // positionieren
        position = CGPoint(x: szene.frame.midX, y: CGFloat(20))
        // und hinzufügen
        self.szene.addChild(self)
    }
    
    
    // die Methode für die Bewegungen des Raumschiffs
    func bewegen(richtung: Int) {
        // wenn wir nicht schon am Rand angekommen sind
        // und es nach links gehen soll
        if position.x > 50 && richtung == -1 {
            run(SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 0.3))
        }
        
        // wenn wir nicht schon am Rand angekommen sind
        // und es nach rechts gehen soll
        if position.x < szene.frame.maxX - 50 && richtung == 1 {
            run(SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 0.3))
        }
    }
    
    
    // die Methode zum Feuern mit dem Raumschiff
    func feuern() {
        // das Sprite erzeugen
        let munitionSprite = SKSpriteNode(imageNamed: "munition_verteidiger")
        
        
        // die Formen für die Kollisionsprüfung
        // hier ein Rechteck in der Größe des Sprites
        munitionSprite.physicsBody = SKPhysicsBody(rectangleOf: munitionSprite.size)
        // das Bild für das Geschoss zuweisen
        munitionSprite.name = "raumschiffGeschoss"
        
        // das Raumschiffgeschoss bekommt die Kategorie 3 = 0b11
        // sie muss als Bitmaske als binärer Wert angegeben werden
        munitionSprite.physicsBody?.categoryBitMask = 0b11
        // es ragiert nicht auf Kollisionen
        munitionSprite.physicsBody?.collisionBitMask = 0
        
        
        // die Munition oben in der Mitte des Raumschiffs positionieren
        munitionSprite.position = CGPoint(x: frame.midX, y: frame.maxY)
        // und hinzufügen
        szene.addChild(munitionSprite)
        
        // die Munition nach oben bewegen
        munitionSprite.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: 200), duration: 1.0)))
    }
}
