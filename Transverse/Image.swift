//
//  Image.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class Image {
    var uvCoordinates: [Float] = [Float]()
    var vertices: [Float] = [Float]()
    var drawOrder: [GLushort] = [GLushort]()
    var textureHandle: GLuint = 0
    
    init () {
        
    }
    
    func draw(verticeHandle: GLuint, uvCoordinateHandle: GLuint, textureVariableHandle: GLint) {
        glEnableVertexAttribArray(verticeHandle)
        
        glVertexAttribPointer(verticeHandle, 3, GLenum(GL_FLOAT), UInt8(GL_FALSE), 0, vertices)
        
        glEnableVertexAttribArray(uvCoordinateHandle)
        
        glVertexAttribPointer(uvCoordinateHandle, 2, GLenum(GL_FLOAT), UInt8(GL_FALSE), 0, uvCoordinates)
        
        glUniform1i(textureVariableHandle, GLint(textureHandle))
        
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(drawOrder.count), GLenum(GL_UNSIGNED_SHORT), drawOrder)
        
        
        glDisableVertexAttribArray(verticeHandle)
        glDisableVertexAttribArray(uvCoordinateHandle)
    }
}