//
//  GameLevelEnd.swift
//  SpaceInvaders_v.2.0
//
//  Created by Iman Kefayati on 29.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import SpriteKit

class GameLevelEnd: SKScene {
    // für die Punkte
    var punkte = 0
    // ein Label für die Endpunkte
    let labePunkte = SKLabelNode()
    
    // ein Label für die Meldung
    let labelMeldung = SKLabelNode()
    
    
    init(size: CGSize, punkte: Int) {
        // den Konstruktor der übergeordneten Klasse aufrufen
        // und die Größe durchreichen
        super.init(size: size)
        
        // die Punkte setzen
        self.punkte = punkte
    }
    
    // der Initialisierer wird durch die Basisklasse erzwungen
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        // der Hintergrund ist schwarz
        backgroundColor = SKColor.black
        
        // die Meldung ausgeben
        labelMeldung.fontSize = 74
        labelMeldung.fontColor = SKColor.white
        labelMeldung.text = "GAME OVER 🥴"
        
        // das Label positionieren
        labelMeldung.position = CGPoint(x: frame.maxX / 2, y: (frame.maxY / 2) + 100)
        
        // und hinzufügen
        addChild(labelMeldung)
        
        
        // die Punkte ausgeben
        labePunkte.fontSize = 50
        labePunkte.fontColor = SKColor.white
        labePunkte.text = String(punkte) + " Punkte"
        
        // das Label Positionieren
        labePunkte.position = CGPoint(x: frame.maxX / 2, y: labelMeldung.position.y - 70)
        
        // und hinzufügen
        addChild(labePunkte)
    }
    
    override func mouseDown(with event: NSEvent) {
        // die Anwendung durch ein Mausklick beenden
        NSApplication.shared.terminate(self)
    }
}
