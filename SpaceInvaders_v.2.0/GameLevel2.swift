//
//  GameLevel2.swift
//  SpaceInvaders_v.2.0
//
//  Created by Iman Kefayati on 02.05.20.
//  Copyright © 2020 Iman Kefayati. All rights reserved.
//

import SpriteKit

class GameLevel2: SKScene, SKPhysicsContactDelegate {
    
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
    
    
    // zur Beschaffung der Punkte- und Energiestand
    // aus GameLevel1
    init(size: CGSize, punkte: Int, energie: Int) {
        // den Konstruktor der übergeordneten Klasse aufrufen
        // und die Größe durchreichen
        super.init(size: size)
        
        // die Punkte setzen
        self.punkte = punkte
        self.energie = energie
    }
    
    // der Initialisierer wird durch die Basisklasse erzwungen
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
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
        
        
        // für die Positionierung der Endgegners
        var zeile = 1
        var spalte = 1
        
        // die Endgegner erzeugen
        for _ in 0 ..< 8 {
            
            // ein neuer Endgegner erzeugen
            // übergeben wird die Nummer für die Grafik
            var meinEndgegner = EndGegner()
            
            // das Alien in die Szene setzen
           meinEndgegner.setzePosition(szene: self, startPos: CGPoint(x: CGFloat(150 + (spalte * 50)), y: CGFloat(500 + (zeile * 50))))
           
            
            // die Spalte erhöhen
            spalte = spalte + 2
            // wenn alle Spalten gefüllt sind, geht es mit der nächsten
            // Zeile weiter
            if spalte == 8 {
                zeile = zeile + 0
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
            // gibt es schon ein Geschoss in der Szene?
            if childNode(withName: "raumschiffGeschoss") == nil {
                meinRaumschiff.feuern()
            }
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
        
        
        // MARK: - Aufgabe 1 - Anfang -
        
        // eine Variable zur Berechnung des Levelgegners
        var level = 1
        // eine Variable zur Angangsposition
        var anfangsWert: CGFloat = 0.0
        
        // durchlaufen alle Knoten, die den Namen "alien" haben
        enumerateChildNodes(withName: "endgegner") {
            knoten, stop in
            
            // zur Sicherheit prüfen, ob eine Umwandlung möglich ist
            if let meinEndgegner = knoten as? EndGegner {
                
                // Überprüfung, ob die aktuelle Position > ist als
                // der Anfangswert
                if anfangsWert < meinEndgegner.getPosition() {
                    anfangsWert = meinEndgegner.getPosition()
                }
            }
        }
        
        // das Level zur aktuellen Position setzen
        level = self.setLevel(position: anfangsWert)
    
        // MARK: - Aufgabe 1 - Ende -
        
        
        // die verringerte Vergleichszeit isr für das Schwirigkeitsgrad wichtig
        if zwischenZeit >= (0.4 / Double(level)) { // das ist ebenfalls für Aufgabe 1
            // durchlaufen alle Knoten, die den Namen "alien" haben
            enumerateChildNodes(withName: "endgegner") {
                // die Verarbeitung abbrechen können
                knoten, stop in
                
                // zur Sicherheit prüfen, ob eine Umwandlung möglich ist
                if let meinEndgegner = knoten as? EndGegner {
                    richtungsWechsel = meinEndgegner.bewegen(rechtsLinks: self.rechtsLinks, nachUnten: 0)
                    
                    // muss die Richtung gewechselt werden?
                    if richtungsWechsel == true {
                        // dann geht es nach unten
                        self.nachUnten = 1
                        
                        // die Schleife beenden
                        stop.pointee = true
                    }
                    meinEndgegner.feuern()
                }
            }
            
            if self.nachUnten == 1 {
                // alle bewegen sich eine Position nach unten
                // durchlaufen alle Knoten, die den Namen "alien" haben
                enumerateChildNodes(withName: "endgegner") {
                    // die Verarbeitung abbrechen können
                    knoten, stop in
                    
                    // zur Sicherheit prüfen, ob eine Umwandlung möglich ist
                    if let meinEndgegner = knoten as? EndGegner {
                        richtungsWechsel = meinEndgegner.bewegen(rechtsLinks: 0, nachUnten: 1)
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
    
    
    // MARK: - Kollisionsprüfung und Punktevergabe für Endgegner -
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // ist ein Endgegner mit einem Geschoss des Raumschiffs kollidiert?
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == 0b11000 {
            
            // dann zerstören wir die beiden Objekte
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            // wir erhöhen die Punkte und geben sie aus
            punkte = punkte + 40
            labelPunkte.text = String(punkte)
            
            // einen Sound für das zerstören des Alienraumschiffes
            run(SKAction.playSoundFileNamed("alien_explosion.mp3", waitForCompletion: false))
            
            // zum Testen geben wir noch eine Meldung aus
            print("Endgegner getroffen")
        }
        
        // ist ein Geschoss des Endgegners mit dem Raumschiff kollidiert?
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == 0b100001 {
            
            // dann zerstören wir das Geschoss
            contact.bodyB.node?.removeFromParent()
            
            // wir ziehen Energie des Raumschiffes ab
            energie = energie - 20
            labelEnergie.text = String(energie)
            
            // einen Sound für das treffen des Raumschiffes durch die Aliens
            run(SKAction.playSoundFileNamed("alien_explosion.m4a", waitForCompletion: false))
            
            // zum Testen geben wir noch eine Meldung aus
            print("Raumschoff vom Endgegner getroffen")
        }
        
        // ist ein Endgegner mit dem Raumschiff kollidiert?
        if contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask == 0b10001 {
            
            // dann zerstören wir die beiden Objekte
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            
            // Der Energie des Raumschiffes wird auf 0 gesetzt
            energie = 0
            labelEnergie.text = String(energie)
            
            // einen Sound für das zerstören des Raumschiffes
            run(SKAction.playSoundFileNamed("raumschiff_explosion.m4a", waitForCompletion: false))
            
            // zum Testen geben wir noch eine Meldung aus
            print("Raumschiff ist mit dem Endgegner Kollidiert")
        }
        
        // prüfen, ob das Spiel beendet werden muss
        istSpielZuEnde()
    }
    
    
    // Hier überprüfen wir, ob das Spiel beendet werden muss
    func istSpielZuEnde() {
        // ist die Energie gleich 0 oder kein Alien mehr im Spiel?
        if energie == 0 || childNode(withName: "endgegner") == nil {
            // dann rufen wir die Endszene auf und übergeben die Punkte
            self.view?.presentScene(GameLevelEnd(size: self.size, punkte: self.punkte), transition: SKTransition.flipHorizontal(withDuration: 1.0))
        }
    }
    
    // MARK: - Aufgabe 1 - Anfang -
    
    // zur Festsetzung der Levelrate anhand eine Prozentberechnung
    // wieviel weg schon in Prozent zurückgelegt wurde
    func setLevel (position: CGFloat) -> Int {
        // zur Einteilung verschiedene Levelbereichen
        var lvlNr = 1
        
        // Der Weg in Prozenten
        let procent = position / frame.maxY * 100
        
        
        // verbleibender Weg von 80 %
        if procent < 80 {
            lvlNr = 5
        }
        
        // verbleibender Weg von 60 %
        if procent < 60 {
            lvlNr = 10
        }
        
        // verbleibender Weg von 50 %
        if procent < 50 {
            lvlNr = 20
        }
        
        // verbleibender Weg von 20 %
        if procent < 20 {
            lvlNr = 30
        }
        
        return lvlNr
    }
    // MARK: - Aufgabe 1 - Ende -
}
