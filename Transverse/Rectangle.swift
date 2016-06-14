//
//  Rectangle.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class Rectangle: Shape {
    var origin: (x: Float, y: Float, z: Float) = (0,0,0)
    var width: Float = 0
    var height: Float = 0
    
    var vertices: [Float] = [Float]()
    var drawOrder: [GLushort] = [GLushort]()
    
    
    func refresh() {
        drawOrder = [0, 1, 2, 0, 2, 3]
        
        vertices = [
            origin.x, origin.y, origin.z,
            origin.x, origin.y + height, origin.z,
            origin.x + width, origin.y + height, origin.z,
            origin.x + width, origin.y, origin.z
        ]
    }
    
    func draw(verticeMatrixHandle: GLint) {
        
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, vertices)
        glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(drawOrder.count), GLenum(GL_UNSIGNED_SHORT), drawOrder)
        
    }
    
    func containsPoint(x: Float, y: Float) -> Bool {
        if (x >= origin.x && x <= origin.x + width && y >= origin.y && y <= origin.y + height) {
            return true
        }
        return false
    }
    
    func lineSegmentCrosses(startX: Float, startY: Float, endX: Float, endY: Float) -> Bool {
        if (UtilityMath.lineSegmentsCross(origin.x, y1: origin.y, x2: origin.x + width, y2: origin.y, x3: startX, y3: startY, x4: endX, y4: endY)
            || UtilityMath.lineSegmentsCross(origin.x, y1: origin.y, x2: origin.x, y2: origin.y + height, x3: startX, y3: startY, x4: endX, y4: endY)
            || UtilityMath.lineSegmentsCross(origin.x + width, y1: origin.y, x2: origin.x + width, y2: origin.y + height, x3: startX, y3: startY, x4: endX, y4: endY)
            || UtilityMath.lineSegmentsCross(origin.x, y1: origin.y + height, x2: origin.x + width, y2: origin.y + height, x3: startX, y3: startY, x4: endX, y4: endY)){
            return true;
        }
        return false;
    }
}