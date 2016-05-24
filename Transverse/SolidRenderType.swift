//
//  SolidRenderType.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class SolidRenderType: RenderType {
    var alpha: Float = 1
    var matrix: GLKMatrix4? = nil
    var color: (red: Float, green: Float, blue: Float) = (1, 1, 1)
    
    init() {
        
    }
    
    func drawAlphaShape(shape: AlphaShape) {
        glUseProgram(Shaders.solidLineProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.solidLineProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.solidLineProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.solidLineProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.blue, color.green, alpha)
        
        let alphaHandle: GLint = glGetAttribLocation(Shaders.solidLineProgram, "aAlpha")
        
        shape.draw(positionHandle, alphaHandle: alphaHandle)
    }
    
    func drawShape(shape: Shape) {
        glUseProgram(Shaders.solidColorProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.solidColorProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.solidColorProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.solidColorProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.blue, color.green, alpha)
        
        shape.draw(positionHandle)
    }
    
    func drawImage(image: Image) {
        glUseProgram(Shaders.solidImageProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.solidImageProgram, "vPosition")
        
        let mTexCoordLoc: GLint = glGetAttribLocation(Shaders.solidImageProgram, "a_texCoord")
        
        let mSamplerLoc: GLint = glGetUniformLocation(Shaders.solidImageProgram, "s_texture")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.solidImageProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.solidImageProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.blue, color.green, alpha)
        
        image.draw(GLuint(positionHandle), uvCoordinateHandle: GLuint(mTexCoordLoc), textureVariableHandle: mSamplerLoc)
    }
    
    func drawText(text: Text) {
        drawImage(text.textImage!)
    }
}