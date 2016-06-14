//
//  RoundedRectangle.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class RoundedRectangle: Shape {
    var cornerRadius: Float = 0
    var center: (x: Float, y: Float, z: Float) = (0,0,0)
    var precision: Int = 0
    var width: Float = 0
    var height: Float = 0
    
    var trianglesVertice: [Float] = [Float]()
    var trianglesDrawOrder: [GLushort] = [GLushort]()
    
    var topLeftVertices: [Float] = [Float]()
    var topRightVertices: [Float] = [Float]()
    var bottomLeftVertices: [Float] = [Float]()
    var bottomRightVertices: [Float] = [Float]()
    
    func refresh() {
        trianglesDrawOrder = [
            0, 1, 2, 0, 2, 3, //left edge, right edge and center square
            4, 5, 6, 4, 6, 7, //top edge
            8, 9, 10, 8, 10, 11 //bottom edge
        ]
        
        trianglesVertice = [
            center.x - width/2, center.y + height/2 - cornerRadius, center.z,
            center.x - width/2, center.y - height/2 + cornerRadius, center.z,
            center.x + width/2, center.y - height/2 + cornerRadius, center.z,
            center.x + width/2, center.y + height/2 - cornerRadius, center.z,
            
            center.x - width/2 + cornerRadius, center.y + height/2, center.z,
            center.x - width/2 + cornerRadius, center.y + height/2 - cornerRadius, center.z,
            center.x + width/2 - cornerRadius, center.y + height/2 - cornerRadius, center.z,
            center.x + width/2 - cornerRadius, center.y + height/2, center.z,
            
            center.x - width/2 + cornerRadius, center.y - height/2, center.z,
            center.x - width/2 + cornerRadius, center.y - height/2 + cornerRadius, center.z,
            center.x + width/2 - cornerRadius, center.y - height/2 + cornerRadius, center.z,
            center.x + width/2 - cornerRadius, center.y - height/2, center.z
        ]
        
        topLeftVertices = [Float](count: precision*3 + 3, repeatedValue: 0)
        topLeftVertices[0] = center.x - width/2 + cornerRadius
        topLeftVertices[1] = center.y + height/2 - cornerRadius
        topLeftVertices[2] = center.z
        for i in 0...(precision-1) {
            let ratio : Float = Float(i)/Float(precision - 1)
            let angle: Float = ratio * Float(M_PI) / 2.0 + Float(M_PI) / 2.0
            topLeftVertices[i*3 + 3] = cornerRadius * cos(angle) + topLeftVertices[0];
            
            topLeftVertices[i*3 + 4] = cornerRadius * sin(angle) + topLeftVertices[1];
            topLeftVertices[i*3 + 5] = center.z;
        }
        
        topRightVertices = [Float](count: precision*3 + 3, repeatedValue: 0)
        topRightVertices[0] = center.x + width/2 - cornerRadius;
        topRightVertices[1] = center.y + height/2 - cornerRadius;
        topRightVertices[2] = center.z;
        for i in 0...(precision-1) {
            let ratio : Float = Float(i)/Float(precision - 1)
            let angle: Float = ratio * Float(M_PI) / 2.0
            topRightVertices[i*3 + 3] = cornerRadius * cos(angle) + topRightVertices[0];
            
            topRightVertices[i*3 + 4] = cornerRadius * sin(angle) + topRightVertices[1];
            topRightVertices[i*3 + 5] = center.z;
        }
        
        bottomLeftVertices = [Float](count: precision*3 + 3, repeatedValue: 0)
        bottomLeftVertices[0] = center.x - width/2 + cornerRadius;
        bottomLeftVertices[1] = center.y - height/2 + cornerRadius;
        bottomLeftVertices[2] = center.z;
        for i in 0...(precision-1) {
            let ratio : Float = Float(i)/Float(precision - 1)
            let angle: Float = ratio * Float(M_PI) / 2.0 + Float(M_PI)
            bottomLeftVertices[i*3 + 3] = cornerRadius * cos(angle) + bottomLeftVertices[0];
            
            bottomLeftVertices[i*3 + 4] = cornerRadius * sin(angle) + bottomLeftVertices[1];
            bottomLeftVertices[i*3 + 5] = center.z;
        }
        
        bottomRightVertices = [Float](count: precision*3 + 3, repeatedValue: 0)
        bottomRightVertices[0] = center.x + width/2 - cornerRadius;
        bottomRightVertices[1] = center.y - height/2 + cornerRadius;
        bottomRightVertices[2] = center.z;
        for i in 0...(precision-1) {
            let ratio : Float = Float(i)/Float(precision - 1)
            let angle: Float = ratio * Float(M_PI) / 2.0 + Float(3*M_PI/2)
            bottomRightVertices[i*3 + 3] = cornerRadius * cos(angle) + bottomRightVertices[0];
            
            bottomRightVertices[i*3 + 4] = cornerRadius * sin(angle) + bottomRightVertices[1];
            bottomRightVertices[i*3 + 5] = center.z;
        }
        
    }
    
    func draw(verticeMatrixHandle: GLint) {
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, trianglesVertice)
        glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(trianglesDrawOrder.count), GLenum(GL_UNSIGNED_SHORT), trianglesDrawOrder)
        
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, topLeftVertices)
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, precision + 1)
        
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, topRightVertices)
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, precision + 1)
        
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, bottomLeftVertices)
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, precision + 1)
        
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, bottomRightVertices)
        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, precision + 1)
    }
    
    func containsPoint(x: Float, y: Float) -> Bool {
        let topLeftX: Float = center.x - width/2
        let topLeftY: Float = center.y - height/2
        let bottomRightX: Float = center.x + width/2
        let bottomRightY: Float = center.y + height/2
        if (x >= topLeftX && x <= bottomRightX && y >= topLeftY + cornerRadius && y <= bottomRightY - cornerRadius) {
            return true
        } else if (x >= topLeftX + cornerRadius && x <= bottomRightX - cornerRadius && y >= topLeftY && y <= bottomRightY) {
            return true
        } else {
            let dx: Float = min(abs((topLeftX + cornerRadius) - x), abs((bottomRightX - cornerRadius) - x))
            let dy: Float = min(abs((topLeftY + cornerRadius) - y), abs((bottomRightY - cornerRadius) - y))
            if (sqrt(pow(dx, 2) + pow(dy, 2)) <= cornerRadius) {
                return true
            }
        }
        return false;
    }
}