//
//  Path.swift
//  Transverse
//
//  Created by Justin on 5/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class Path: AlphaShape {
    var points: [(x: Float, y: Float)] = [(x: Float, y: Float)]()
    var width: Float = 0
    var vertices: [Float] = [Float]()
    var alpha: [Float] = [Float]()
    
    func removeBottomPoints(numOfPoints: Int) {
        if (numOfPoints == 0) {
            return
        }
        points.removeRange(0...(numOfPoints - 1))
        vertices.removeRange(0...(3*numOfPoints - 1))
        alpha.removeRange(0...(numOfPoints - 1))
    }
    
    func addTopPoint(x: Float, y: Float) {
        points.append((x, y))
        vertices.append(x)
        vertices.append(y)
        vertices.append(0)
        alpha.append(1)
    }
    
    func setAlpha(index: Int, alphaValue: Float) {
        alpha[index] = alphaValue
    }
    
    func refresh() {
        vertices = [Float]()
        alpha = [Float]()
        for point in points {
            vertices.append(point.x)
            vertices.append(point.y)
            vertices.append(0)
            alpha.append(1)
        }
    }
    
    func draw(verticeMatrixHandle: GLint, alphaHandle: GLint){
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, vertices)
        glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
        
        glVertexAttribPointer(GLuint(alphaHandle), 1, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, alpha)
        glEnableVertexAttribArray(GLuint(alphaHandle))
        
        glLineWidth(width)
        
        glDrawArrays(GLenum(GL_LINE_STRIP), 0, Int32(vertices.count/3));
    }
}