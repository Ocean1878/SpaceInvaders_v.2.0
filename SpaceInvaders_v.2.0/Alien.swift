//
//  Alien.swift
//  SpaceInvaders_v.2.0
//
//  Created by Iman Kefayati on 28.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import SpriteKit

class Alien: SKSpriteNode {
    // für die Szene
    var szene: SKScene!
    
    // für die Geschwindigkeit
    let geschwindigkeit = 3
    
    // für die Feuerintensität
    let feuerGeschwindigkeit = 100
    
    // der Initialisierer erzeugt das Alien mit dem Bild,
    // dessen Nummer übergeben wird
    init(textureNummer: Int) {
        // das Bild erzeugen
        let bildName = "invader_0" + String(textureNummer)
        let bild = SKTexture(imageNamed: bildName)
        
        // den Konstruktor der übergeordneten Klasse aufrufen
        super.init(texture: bild, color: NSColor.black, size: bild.size())
        
        // einen Namen setzen
        name = "alien"
    }
    
    // der Initialisierer wird durch die Basisklasse erzwungen
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // die Methode setzt das Alien in die übergebene Szene
    // und zeigt es an
    func setzePosition(szene: SKScene, startPos: CGPoint) {
        // die Szene speichern
        self.szene = szene
        // positionieren
        position = startPos
        self.szene.addChild(self)
        position = startPos
    }
    
    // die Methode erhält die Richtung, in der die Bewegung erfolgt,
    // als Argumente
    // bei einem Kontakt mit dem Rand liefert sie true, sonst false
    func bewegen(rechtsLinks: Int, nachUnten: Int) -> Bool {
        var kontakt = false
        
        // die Richtung wird über die Argumente gesteuert
        // die Geschwindigkeit hängt vom Wert der Eigenschaft
        // geschwindigkeit ab
        position = CGPoint(x: position.x + CGFloat(rechtsLinks * geschwindigkeit), y: position.y - (CGFloat(nachUnten) * size.height))
        
        // gab es ein Kontakt mit dem Rand?
        if position.x < 50 || position.x >= szene.frame.maxX - 50 {
            kontakt = true
            
            // das Sprite neu positionieren
            if position.x <= 50 {
                position.x = 51
            } else {
                position.x = szene.frame.maxX - 51
            }
        }
        return kontakt
    }
    
    // die Methode zum Feuern für die Aliens
    func feuern() {
        // eine zufällige Zahl erzeugen, die obere Grenze wird durch
        // die Eigenschaft bestimmt
        if arc4random_uniform(UInt32(feuerGeschwindigkeit)) == 0 {
            // das Sprite erzeugen
            let munitionSprite = SKSpriteNode(imageNamed: "munition_invader")
            
            // die Munition in der Mitte des Aliens positionieren
            munitionSprite.position = CGPoint(x: frame.midX, y: frame.maxY)
            // und hinzufügen
            szene.addChild(munitionSprite)
            
            // und die Munition nach unten bewegen
            munitionSprite.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: -200), duration: 1.0)))
        }
    }
}