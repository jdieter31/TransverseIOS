//
//  GateSubSection.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class GateSubSection: SubSection {
    var difficulty: Float = 0.5
    var length: Float = 0
    var origin: (x: Float, y: Float) = (0, 0)
    
    var width: Float = 0
    
    var gates: [Gate] = [Gate]()
    
    var inverted: Bool = false
    
    private var minSpacing: Float = 0
    private var angleRange: Float = 0
    private var spacingRange: Float = 0
    private var positionDeviation: Float = 0
    private var positionMean: Float = 0
    private var lengthMinimum: Float = 0
    private var lengthRange: Float = 0
    
    func draw(renderType: RenderType) {
        for gate in gates {
            gate.draw(renderType)
        }
    }
    
    func refresh() {
        for gate in gates {
            gate.refresh()
        }
    }
    
    func handleTouchMove(startX: Float, endX: Float, startY: Float, endY: Float) -> Bool {
        for gate in gates {
            if (gate.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)) {
                return true
            }
        }
        return false
    }
    
    func generate(width: Float, startX: Float, startY: Float) {
        length = max(500, 750 + 750*difficulty + UtilityMath.gaussian()*difficulty*750)
        generate(width, startX: startX, startY: startY, length: length)
    }
    
    func generate(width: Float, startX: Float, startY: Float, length: Float) {
        origin.x = startX
        origin.y = startY
        self.width = width
        self.length = length
        
        minSpacing = 200 - 100*difficulty
        spacingRange = 100*(1-difficulty)*Float(drand48())
        
        angleRange = 0
        if (Float(drand48()) > 0.4) {
            angleRange = Float(drand48())*Float(M_PI)/8
        }
        
        positionDeviation = width / 9 + Float(drand48()) * difficulty * (1.0/3.0)
        positionMean = startX + width/2
        
        
        if (inverted) {
            lengthMinimum = 2*width/5 + difficulty * width/3
            lengthRange = difficulty * width/4
        } else {
            lengthMinimum = width/4 + (1 - difficulty) * width/3
            lengthRange = Float(drand48()) * difficulty * width/4
        }
        
        var lastGateY: Float = 0
        
        var spacing: Float = minSpacing + Float(drand48())*spacingRange
        var gate: Gate = genGate(startY - spacing)
        lastGateY = startY - spacing - gate.getHeight()
        repeat {
            gates.append(gate)
            
            
            spacing = minSpacing + Float(drand48())*spacingRange
            gate = genGate(lastGateY - spacing)
            lastGateY = lastGateY - spacing - gate.getHeight()
        } while (lastGateY - spacing >= startY - length)
        
        lastGateY += gate.getHeight()
        lastGateY += spacing
        if (lastGateY - 220.0 >= startY - length) {
            gate = genGate((startY - length + lastGateY)/2)
            gate.angle = 0
            gate.centerGateY = startY - length + 2 * spacing / 3.0
            gates.append(gate)
        }
        
    }
    
    func genGate(gateStartY: Float) -> Gate{
        let gate: Gate =  Gate();
        var gateX: Float = positionMean + positionDeviation*UtilityMath.gaussian();
        if (gateX > origin.x + width - 50) {
            gateX = origin.x + width - 150;
        } else if (gateX < origin.x + 50) {
            gateX = origin.x + 150;
        }
        let gateLength: Float = lengthMinimum + lengthRange*Float(drand48());
        gate.gateLength = gateLength;
        let gateAngle: Float = -angleRange + Float(drand48())*2*angleRange;
        gate.angle = gateAngle;
        gate.startX = origin.x
        gate.endX = origin.x + width
        let gateWidth: Float = gateLength * cos(-gateAngle)
        let adjustRight: Bool = Float(drand48()) > 0.5;
        if (gateX - gateWidth / 2 - width/3 < origin.x && gateX + gateWidth / 2 + width/3 > origin.x + width) {
            if (adjustRight) {
                gateX = origin.x + width/3 + gateWidth/2;
            } else {
                gateX = origin.x + width - gateWidth/2 - width/3;
            }
        }
        if (gateX - gateWidth / 2 < origin.x) {
            gate.gateLength = 2 * (gateX - origin.x) / cos(gateAngle);
        }
        if (gateX + gateWidth / 2 > origin.x + width) {
            gate.gateLength = 2 * (origin.x + width - gateX) / cos(gateAngle);
        }
        
        var gateY: Float = 0
        if (gateAngle > 0) {
            gateY = gateStartY - abs((gateX - origin.x) * tan(gateAngle));
        } else {
            gateY = gateStartY - abs((origin.x + width - gateX) * tan(gateAngle));
        }
        gate.centerGateX = gateX
        gate.centerGateY = gateY
        if (inverted) {
            gate.inverted = true
        }
        return gate;
    }
    
    func flip() {
        for gate in gates {
            gate.angle = -gate.angle
            gate.centerGateX = origin.x + width - (gate.centerGateX - origin.x)
        }
    }
    
    func empty() {
        gates = [Gate]()
    }
    
    func setOrigin(x: Float, y: Float) {
        for gate in gates {
            gate.centerGateX = x + gate.centerGateX - origin.x
            gate.centerGateY = y + gate.centerGateY - origin.y
            gate.startX = x
            gate.endX = x + width
        }
        origin.x = x
        origin.y = y
    }
    
    func copy() -> SubSection {
        let copy : GateSubSection = GateSubSection()
        copy.length = length
        for gate in gates {
            let gateCopy: Gate = Gate()
            gateCopy.angle = gate.angle
            gateCopy.startX = gate.startX
            gateCopy.endX = gate.endX
            gateCopy.centerGateY = gate.centerGateY
            gateCopy.centerGateX = gate.centerGateX
            gateCopy.inverted = inverted
            copy.gates.append(gateCopy)
        }
        copy.origin.x = origin.x
        copy.origin.y = origin.y
        copy.width = width
        copy.inverted = inverted
        return copy
    }
}