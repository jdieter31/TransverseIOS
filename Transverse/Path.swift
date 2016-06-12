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

class Path {
    var points: [(x: Float, y: Float)] = [(x: Float, y: Float)]()
    var width: Float = 0
    var vertices: [Float] = [Float]()
    var alpha: [Float] = [Float]()
    
    func removeBottomPoints(numOfPoints: Int) {
        if (numOfPoints == 0) {
            return
        }
        for i in 0...numOfPoints - 1 {
            let point = points[i]
            var index = -1
            for j in 0...(vertices.count/3 - 1) {
                if (vertices[3*j] == point.x && vertices[3*j + 1] == point.y) {
                    index = j
                    break
                }
            }
            vertices.removeRange(0...(3*index + 2))
            alpha.removeRange(0...index)
        }
        points.removeRange(0...(numOfPoints - 1))
    }
    
    func addTopPoint(x: Float, y: Float) {
        points.append((x, y))
        if (points.count >= 2) {
            insertSegment(points[points.count - 2], point: points[points.count - 1])
        } else {
            vertices.append(x)
            vertices.append(y)
            vertices.append(0)
            alpha.append(1)
        }
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
    
    func setAlpha(index: Int, alphaValue: Float) {
        if (index == 0) {
            alpha[0] = alphaValue
        } else {
            let prevPoint = points[index - 1]
            var prevPointIndex = -1
            for j in 0...(vertices.count/3 - 1) {
                if (vertices[3*j] == prevPoint.x && vertices[3*j + 1] == prevPoint.y) {
                    prevPointIndex = j
                    break
                }
            }
            let point = points[index]
            var pointIndex = -1
            for j in 0...(vertices.count/3 - 1) {
                if (vertices[3*j] == point.x && vertices[3*j + 1] == point.y && j != prevPointIndex) {
                    pointIndex = j
                    break
                }
            }
            for i in (prevPointIndex+1)...pointIndex {
                alpha[i] = alphaValue
            }
        }
    }
    
    func refresh() {
        vertices = [Float]()
        alpha = [Float]()
        var prevPoint: (x: Float, y: Float)? = nil
        for point in points {
            if let prevPoint = prevPoint {
                insertSegment(prevPoint, point: point)
            } else {
                vertices.append(point.x)
                vertices.append(point.y)
                vertices.append(0)
                alpha.append(1)
            }
            prevPoint = point
        }
    }
    
    func draw(verticeMatrixHandle: GLint, alphaHandle: GLint, pointSizeHandle: GLint){
        glVertexAttribPointer(GLuint(verticeMatrixHandle), 3, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, vertices)
        glEnableVertexAttribArray(GLuint(verticeMatrixHandle))
        
        glVertexAttribPointer(GLuint(alphaHandle), 1, GLenum(GL_FLOAT), UInt8(GL_FALSE),
                              0, alpha)
        glEnableVertexAttribArray(GLuint(alphaHandle))
        
        glUniform1f(pointSizeHandle, width);
        
        glDrawArrays(GLenum(GL_POINTS), 0, Int32(vertices.count/3));
    }
}