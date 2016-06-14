//
//  Circle.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class Circle: Shape {
    var radius: Float = 0.0
    var centerX: Float = 0.0
    var centerY: Float = 0.0
    var centerZ: Float = 0.0
    var precision: Int = 0
    
    var startAngle: Float = 0
    var endAngle: Float = Float(2 * M_PI)
    
    var isOutline: Bool = false
    var outlineWidth: Float = 0.0
    
    var outlineVerticeArray: [GLfloat] = [GLfloat]()
    
    var verticeArray: [GLfloat] = [GLfloat]()
    
    init() {
        
    }
    
    func refresh() {
        if (!isOutline) {
            verticeArray = [Float](count: precision * 3 + 6, repeatedValue: 0)
            verticeArray[0] = centerX
            verticeArray[1] = centerY
            verticeArray[2] = centerZ
            //Make all angles negatives since y is inverted and we want angle to go clockwise
            let totalAngle: Float = -(endAngle - startAngle);
            for i in 0...precision {
                verticeArray[(i + 1) * 3] = radius * cos(Float(i) / Float(precision) * totalAngle - startAngle) + centerX
                verticeArray[(i + 1) * 3 + 1] = radius * sin(Float(i) / Float(precision) * totalAngle - startAngle) + centerY
                verticeArray[(i + 1) * 3 + 2] = centerZ
            }
        } else {
            outlineVerticeArray = [Float](count: precision * 3 * 2 + 6, repeatedValue: 0);
            let totalAngle: Float = -(endAngle - startAngle);
            for i in 0...precision {
                outlineVerticeArray[i * 3 * 2] = (radius - outlineWidth/2) * cos(Float(i) / Float(precision) * totalAngle - startAngle) + centerX;
                outlineVerticeArray[i * 3 * 2 + 1] = (radius - outlineWidth/2) * sin(Float(i) / Float(precision) * totalAngle - startAngle) + centerY
                outlineVerticeArray[i * 3 * 2 + 2] = centerZ
                outlineVerticeArray[i * 3 * 2 + 3] = (radius + outlineWidth/2) * cos(Float(i) / Float(precision) * totalAngle - startAngle) + centerX
                outlineVerticeArray[i * 3 * 2 + 4] = (radius + outlineWidth/2) * sin(Float(i) / Float(precision) * totalAngle - startAngle) + centerY
                outlineVerticeArray[i * 3 * 2 + 5] = centerZ
            }
        
        }
    }
    
    func draw(verticeMatrixHandle: GLint) {
        if (isOutline) {
            glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                                         0, outlineVerticeArray)
            glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
            glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, precision*2 + 2);
        } else {
            glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                                         0, verticeArray)
            glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
            glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, precision + 2)
        }
    }
    
    func containsPoint(x: Float, y: Float) -> Bool {
        let dx = x - centerX
        let dy = y - centerY
        return sqrt(pow(dx, 2) + pow(dy, 2)) <= radius
    }
}