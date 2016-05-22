//
//  Line.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class Line: AlphaShape {
    
    var verticeArray: [GLfloat] = [GLfloat]()
    var startPoint: (x: Float, y: Float, z: Float) = (0, 0 ,0)
    var endPoint: (x: Float, y: Float, z: Float) = (0, 0, 0)
    var width: Float = 0
    
    var vertices: [GLfloat] = [GLfloat]()
    var alpha: [GLfloat] = [GLfloat]()
    
    init() {
        
    }
    
    func refresh() {
        var widthX: Float;
        var widthY: Float;
        if (endPoint.y - startPoint.y != 0 && endPoint.y - startPoint.y != 0) {
            let slope: Float = -1.0 / ((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x))
            widthX = (width/2) / sqrt(pow(slope, 2) + 1)
            widthY = widthX * slope
        } else if (endPoint.y - startPoint.y == 0) {
            widthX = 0;
            widthY = width/2;
        } else {
            widthX = width/2;
            widthY = 0;
        }
        let alphaY: Float = min(widthY/2, 1)
        let alphaX: Float = min(widthX/2, 1)
        vertices = [
            startPoint.x - widthX, startPoint.y - widthY, startPoint.z,
            endPoint.x - widthX, endPoint.y - widthY, startPoint.z,
            startPoint.x - widthX + alphaX, startPoint.y - widthY + alphaY, startPoint.z,
            endPoint.x - widthX + alphaX, endPoint.y - widthY + alphaY, startPoint.z,
            startPoint.x + widthX - alphaX, startPoint.y + widthY - alphaY, startPoint.z,
            endPoint.x + widthX - alphaX, endPoint.y + widthY - alphaY, startPoint.z,
            startPoint.x + widthX, startPoint.y + widthY, startPoint.z,
            endPoint.x + widthX, endPoint.y + widthY, startPoint.z
        ]
        
        alpha = [0,0,1,1,1,1,0,0]

    }
    
    func draw(verticeMatrixHandle: GLint, alphaHandle: GLint) {
            glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                                  0, vertices)
            glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
        
            glVertexAttribPointer(GLuint(alphaHandle), 1, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, alpha)
            glEnableVertexAttribArray(GLuint(alphaHandle))
        
            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 8);

    }
    
    func lineSegmentCrosses(startX: Float, startY: Float, endX: Float, endY: Float) -> Bool {
        var widthX: Float
        var widthY: Float
        if (endPoint.y - startPoint.y != 0 && endPoint.x - startPoint.x != 0) {
            let slope: Float = -1.0 / ((endPoint.y - startPoint.y) / (endPoint.x - startPoint.x))
            widthX = (width/2) / sqrt(pow(slope, 2) + 1)
            widthY = widthX * slope
        } else if (endPoint.y - startPoint.y == 0) {
            widthX = 0
            widthY = width/2
        } else {
            widthX = width/2
            widthY = 0
        }
        return (UtilityMath.lineSegmentsCross(startX, y1: startY, x2: endX, y2: endY, x3: startPoint.x + widthX, y3: startPoint.y + widthY, x4: endPoint.x + widthX, y4: endPoint.y + widthY)
            || UtilityMath.lineSegmentsCross(startX, y1: startY, x2: endX, y2: endY, x3: startPoint.x - widthX, y3: startPoint.y - widthY, x4: endPoint.x - widthX, y4: endPoint.y - widthY)
            || UtilityMath.lineSegmentsCross(startX, y1: startY, x2: endX, y2: endY, x3: startPoint.x + widthX, y3: startPoint.y + widthY, x4: startPoint.x - widthX, y4: startPoint.y - widthY)
            || UtilityMath.lineSegmentsCross(startX, y1: startY, x2: endX, y2: endY, x3: endPoint.x + widthX, y3: endPoint.y + widthY, x4: endPoint.x - widthX, y4: endPoint.y - widthY))
    }
}