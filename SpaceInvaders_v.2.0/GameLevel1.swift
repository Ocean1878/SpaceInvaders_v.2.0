//
//  GameLevel1.swift
//  SpaceInvaders_v.2.0
//
//  Created by Iman Kefayati on 28.04.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import SpriteKit

class GameLevel1: SKScene, SKPhysicsContactDelegate {
    
    // für die Punkte
    var punkte = 0
    let labelPunkte = SKLabelNode()
    
    // für die Energie
    var energie = 100
    let labelEnergie = SKLabelNode()
    
    // das Raumschiff
    var meinRaumschiff = Raumschiff()
    
    // für die Bewegung der Aliens
    var rechtsLinks = -1
    var nachUnten = 0
    
    // für die Zeitsteuerung
    var letzterAufruf: TimeInterval = 0
    var zwischenZeit: TimeInterval = 0
    
    
    override func didMove(to view: SKView) {
        // das Label für die Punkte positionieren
        labelPunkte.fontSize = 24
        labelPunkte.fontColor = SKColor.white
        labelPunkte.position = CGPoint(x: frame.maxX - 50, y: frame.maxY - 50)
        labelPunkte.text = String(punkte)
        // und hinzufügen
        addChild(labelPunkte)
        
        // das zweite Labe für die Energie positionieren
        labelEnergie.fontSize = 24
        labelEnergie.fontColor = SKColor.white
        labelEnergie.position = CGPoint(x: CGFloat(50), y: frame.maxY - 50)
        labelEnergie.text = String(energie)
        // und hinzufügen
        addChild(labelEnergie)
        
        // das Raumschif positionieren
        // eine Instanz der Klasse Raumschiff
        meinRaumschiff.setzePosition(szene: self)
        
        // für das Positionieren der Aliens
        var zeile = 1
        var spalte = 1
        
        // die Aliens erzeugen
        for _ in 0 ..< 42 {
            // ein neues Alien erzeugen
            // übergeben wird die Nummer für die Grafik
            var meinAlien = Alien(textureNummer: zeile)
            
            // das Alien in die Szene setzen
           meinAlien.setzePosition(szene: self, startPos: CGPoint(x: CGFloat(150 + (spalte * 50)), y: CGFloat(500 + (zeile * 50))))
           
            
            // die Spalte erhöhen
            spalte = spalte + 1
            // wenn alle Spalten gefüllt sind, geht es mit der nächsten
            // Zeile weiter
            if spalte == 15 {
                zeile = zeile + 1
                spalte = 1
            }
        }
        
        // die Physikengine aktivieren, aber ohne Schwerkraft
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        // die Szene reagiert selbst auf eine Kollision und
        // wird bei einer Kollision aufgerufen
        physicsWorld.contactDelegate = self
    }
    
    
    override func keyDown(with event: NSEvent) {
        // die Steuerung erfolgt sowohl mit der Pfeiltasten,
        // als auch mit Taste "A" und "D"
        // das Feuern sowohl mit der Leertaste,
        // als auch mit Taste "F"
        switch event.keyCode {
        // nach links
        case 123, 0:
            meinRaumschiff.bewegen(richtung: -1)
        // nach rechts
        case 124, 2:
            meinRaumschiff.bewegen(richtung: 1)
        // feuern
        case 49, 3:
            meinRaumschiff.feuern()
        default:
            print(event.keyCode)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // die Zeit seit dem letzten Aufruf berechnen
        // letzter Aufruf ist eine Eigenschaft vom Typ TimeInterval
        let delta: TimeInterval = currentTime - letzterAufruf
        
        // für den Richtungswechsel
        var richtungsWechsel = false
        
        // zwischenZeit ist eine Eigenschaft vom Typ TimeInterval
        // die Zeiten zusammenrechnen
        zwischenZeit = zwischenZeit + delta
        
        // haben wir eine Sekunde erreicht?
        if zwischenZeit >= 1.0 {
            // durchlaufen alle Knoten, die den Namen "alien" haben
            enumerateChildNodes(withName: "alien") {
                // die Verarbeitung abbrechen können
                knoten, stop in
                
                // zur Sicherheit prüfen, ob eine Umwandlung möglich ist
                if let meinAlien = knoten as? Alien {
                    richtungsWechsel = meinAlien.bewegen(rechtsLinks: self.rechtsLinks, nachUnten: 0)
                    
                    // muss die Richtung gewechselt werden?
                    if richtungsWechsel == true {
                        // dann geht es nach unten
                        self.nachUnten = 1
                        
                        // die Schleife beenden
                        stop.pointee = true
                    }
                    meinAlien.feuern()
                }
            }
            
            if self.nachUnten == 1 {
                // alle bewegen sich eine Position nach unten
                // durchlaufen alle Knoten, die den Namen "alien" haben
                enumerateChildNodes(withName: "alien") {
                    // die Verarbeitung abbrechen können
                    knoten, stop in
                    
                    // zur Sicherheit prüfen, ob eine Umwandlung möglich ist
                    if let meinAlien = knoten as? Alien {
                        richtungsWechsel = meinAlien.bewegen(rechtsLinks: 0, nachUnten: 1)
                    }
                }
                // es geht nicht mehr nach unten
                self.nachUnten = 0
                
                // die Richtung wird umgedreht
                self.rechtsLinks = self.rechtsLinks * -1
            }
            
            // die Zeit wird zurückgesetzt
            self.zwischenZeit = 0
        }
        
        // die neue Zeit zwischenspeichern
        letzterAufruf = currentTime
    }
    
    
}
