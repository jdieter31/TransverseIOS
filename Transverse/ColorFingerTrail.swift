//
//  ColorFingerTrail.swift
//  Transverse
//
//  Created by Justin on 6/12/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class ColorFingerTrail: FingerTrail {
    var color: (red: Float, green: Float, blue: Float) = (0,0,0)
    
    var width: Float = 0
    var length: Float = 0
    var vertices: [Float] = [Float]()
    var alpha: [Float] = [Float]()
    
    init(width: Float, length:Float) {
        self.width = width
        self.length = length
        vertices.reserveCapacity(600)
        alpha.reserveCapacity(200)
    }
    
    private func updateAlphaAndRemove() {
        var safeVertices: Int = 0
        var x: Float = 0
        var y: Float = 0
        var lastX: Float = Float.NaN
        var lastY: Float = Float.NaN
        var totalDistance: Float = 0
        var i : Int = vertices.count - 1
        while (i >= 0) {
            let vertex = vertices[i]
            if (i % 3 == 1) {
                y = vertex
            } else if (i % 3 == 0) {
                x = vertex
                if (!lastX.isNaN) {
                    totalDistance += sqrt(pow(x - lastX, 2) + pow(y - lastY, 2))
                    if (totalDistance >= length/2) {
                        alpha[i/3] = (length - totalDistance)/(length / 2)
                    }
                }
                safeVertices += 1
                if (totalDistance >= length) {
                    break
                }
                lastX = x
                lastY = y
            }
            
            i -= 1
        }
        
        if (safeVertices < vertices.count/3) {
            vertices.removeRange(0...((vertices.count/3 - safeVertices)*3 - 1))
            alpha.removeRange(0...((alpha.count - safeVertices) - 1))
        }
    }
    
    func addTopPoint(x: Float, y: Float) {
        if (vertices.count >= 1) {
            insertSegment((x: vertices[vertices.count - 3], y: vertices[vertices.count - 2]), point: (x: x, y: y))
        } else {
            vertices.append(x)
            vertices.append(y)
            vertices.append(0)
            alpha.append(1)
        }
        updateAlphaAndRemove()
    }
    
    func insertSegment(prevPoint: (x: Float, y: Float), point: (x: Float, y: Float)) {
        let distance = sqrt(pow(point.x - prevPoint.x, 2) + pow(point.y - prevPoint.y, 2))
        let numOfPoints = max(Int(10 * distance / width), 1)
        for i in 1...numOfPoints {
            let ratio = Float(i)/Float(numOfPoints)
            vertices.append(prevPoint.x + (point.x - prevPoint.x)*ratio)
            vertices.append(prevPoint.y + (point.y - prevPoint.y)*ratio)
            vertices.append(0)
            alpha.append(1)
        }
    }
    
    func draw(matrix: GLKMatrix4) {
        glUseProgram(Shaders.pathProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.pathProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.pathProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.pathProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.green, color.blue, 1)
        
        let alphaHandle: GLint = glGetAttribLocation(Shaders.pathProgram, "aAlpha")
        
        let mSamplerLoc: GLint = glGetUniformLocation(Shaders.pathProgram, "texture")
        
        glUniform1i(mSamplerLoc, GLint(Textures.particleTexture))
        
        let pointSizeLoc: GLint = glGetUniformLocation(Shaders.pathProgram, "pointSize")
        
        glVertexAttribPointer(GLuint(positionHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, vertices)
        glEnableVertexAttribArray(GLuint(positionHandle))
        
        glVertexAttribPointer(GLuint(alphaHandle), 1, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, alpha)
        glEnableVertexAttribArray(GLuint(alphaHandle))
        
        glUniform1f(pointSizeLoc, width);
        
        glDrawArrays(GLenum(GL_POINTS), 0, Int32(vertices.count/3));
        
    }
}