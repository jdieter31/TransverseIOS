//
//  Gate.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class Gate {
    init() {
        
    }
    
    var angle: Float = 0
    var gateLength: Float = 0
    
    var centerGateX: Float = 0
    var centerGateY: Float = 0
    
    var startX: Float = 0
    var endX: Float = 0
    
    var inverted: Bool = false
    
    private var leftLine: Line?
    private var rightLine: Line?
    
    func draw(renderType: RenderType) {
        renderType.drawAlphaShape(leftLine!)
        if (!inverted) {
            renderType.drawAlphaShape(rightLine!)
        }
    }
    
    func getHeight() -> Float {
        return abs((endX - startX) * tan(angle))
    }
    
    func getWidth() -> Float {
        return endX - startX
    }
    
    func refresh() {
        if (!inverted) {
            leftLine = Line()
            leftLine?.startPoint = (startX - 2.5, centerGateY - (centerGateX - startX)*tan(-angle), 0)
            leftLine?.endPoint = (centerGateX - gateLength / 2 * cos(-angle), centerGateY - gateLength/2 * sin(-angle), 0)
            leftLine?.width = 5
            leftLine?.refresh()
            
            rightLine = Line()
            rightLine?.startPoint = (centerGateX + gateLength / 2 * cos(-angle), centerGateY + gateLength/2 * sin(-angle), 0)
            rightLine?.endPoint = (endX + 2.5, centerGateY + (endX - centerGateX) * tan(-angle), 0)
            rightLine?.width = 5
            rightLine?.refresh()
        } else {
            leftLine = Line()
            leftLine?.startPoint = (centerGateX - gateLength / 2 * cos(-angle), centerGateY - gateLength/2 * sin(-angle), 0)
            leftLine?.endPoint = (centerGateX + gateLength / 2 * cos(-angle), centerGateY + gateLength/2 * sin(-angle), 0)
            leftLine?.width = 5
            leftLine?.refresh()
        }
    }
    
    func lineSegmentCrosses(startX: Float, startY: Float, endX: Float, endY: Float) -> Bool {
        if (leftLine!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)) {
            return true
        }
        if (!inverted) {
            if (rightLine!.lineSegmentCrosses(startX, startY: startY, endX: endX, endY: endY)) {
                return true
            }
        }
        return false
    }
}