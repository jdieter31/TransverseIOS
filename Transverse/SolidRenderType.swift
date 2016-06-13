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
    var color2: (red: Float, green: Float, blue: Float)?
    var width: Float = 0
    var dual: Bool = false
    
    init() {
        
    }
    
    func drawAlphaShape(shape: AlphaShape) {
        if (dual) {
            drawAlphaShapeDual(shape)
            return
        }
        
        glUseProgram(Shaders.solidLineProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.solidLineProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.solidLineProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.solidLineProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.green, color.blue, alpha)
        
        let alphaHandle: GLint = glGetAttribLocation(Shaders.solidLineProgram, "aAlpha")
        
        shape.draw(positionHandle, alphaHandle: alphaHandle)
    }
    
    private func drawAlphaShapeDual(shape: AlphaShape) {
        glUseProgram(Shaders.dualColorAlphaProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.dualColorAlphaProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.dualColorAlphaProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.dualColorAlphaProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.green, color.blue, alpha)
        
        let colorHandle2: GLint = glGetUniformLocation(Shaders.dualColorAlphaProgram, "vColor2");
        glUniform4f(colorHandle2, color2!.red, color2!.green, color2!.blue, alpha)
        
        let widthHandle: GLint = glGetUniformLocation(Shaders.dualColorAlphaProgram, "width")
        glUniform1f(widthHandle, width)
        
        let alphaHandle: GLint = glGetAttribLocation(Shaders.dualColorAlphaProgram, "aAlpha")
        
        shape.draw(positionHandle, alphaHandle: alphaHandle)
    }
    
    func drawShape(shape: Shape) {
        if (dual) {
            drawShapeDual(shape)
            return
        }
        
        glUseProgram(Shaders.solidColorProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.solidColorProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.solidColorProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.solidColorProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.green, color.blue, alpha)
        
        shape.draw(positionHandle)
    }
    
    private func drawShapeDual(shape: Shape) {
        
        glUseProgram(Shaders.dualColorProgram)
        
        let positionHandle: GLint = glGetAttribLocation(Shaders.dualColorProgram, "vPosition")
        
        let matrixHandle: GLint = glGetUniformLocation(Shaders.dualColorProgram, "uMVPMatrix")
        
        if var matrix: GLKMatrix4 = self.matrix {
            withUnsafePointer(&matrix, {
                glUniformMatrix4fv(matrixHandle, 1, GLboolean(GL_FALSE), UnsafePointer($0))
            })
        }
        
        let colorHandle: GLint = glGetUniformLocation(Shaders.dualColorProgram, "vColor");
        glUniform4f(colorHandle, color.red, color.green, color.blue, alpha)
        
        let colorHandle2: GLint = glGetUniformLocation(Shaders.dualColorProgram, "vColor2");
        glUniform4f(colorHandle2, color2!.red, color2!.green, color2!.blue, alpha)
        
        let widthHandle: GLint = glGetUniformLocation(Shaders.dualColorProgram, "width")
        glUniform1f(widthHandle, width)
        
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
        glUniform4f(colorHandle, color.red, color.green, color.blue, alpha)
        
        image.draw(GLuint(positionHandle), uvCoordinateHandle: GLuint(mTexCoordLoc), textureVariableHandle: mSamplerLoc)
    }
    
    func drawText(text: Text) {
        drawImage(text.textImage!)
    }
    
    func setDualColor(color: (red: Float, green: Float, blue: Float), width: Float) {
        dual = true
        color2 = color
        self.width = width
    }
}