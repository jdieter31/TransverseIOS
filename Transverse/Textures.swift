//
//  Textures.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class Textures {
    static var fffForwardFontTexture: GLuint = 0
    static var trophyTexture: GLuint = 0
    static var leaderboardTexture: GLuint = 0
    static var particleTexture: GLuint = 0
    static var fbTexture: GLuint = 0
    static var twitterTexture: GLuint = 0
    static var muteTexture: GLuint = 0
    
    static func loadTextures() {
        fffForwardFontTexture = loadTextureFromFile("forward.png")
        trophyTexture = loadTextureFromFile("trophy.png")
        leaderboardTexture = loadTextureFromFile("leaderboard.png")
        particleTexture = loadTextureFromFile("Particle.png")
        fbTexture = loadTextureFromFile("facebook.png")
        twitterTexture = loadTextureFromFile("twitter.png")
        muteTexture = loadTextureFromFile("mute.png")
    }
    
    private static func loadTextureFromFile(fileName: String) -> GLuint {
        // 1
        let spriteImage: CGImageRef? = UIImage(named: fileName)!.CGImage
        
        if (spriteImage == nil) {
            print("Failed to load image!")
            exit(1)
        }
        
        let width: UInt = UInt(CGImageGetWidth(spriteImage))
        let height: UInt = UInt(CGImageGetHeight(spriteImage))
        let spriteData = UnsafeMutablePointer<GLubyte>(calloc(Int(CGFloat(width) * CGFloat(height) * 4), sizeof(GLubyte)))
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let spriteContext: CGContextRef = CGBitmapContextCreate(spriteData, Int(width), Int(height), 8, Int(width)*4, CGImageGetColorSpace(spriteImage), bitmapInfo.rawValue)!
        
        CGContextDrawImage(spriteContext, CGRectMake(0, 0, CGFloat(width) , CGFloat(height)), spriteImage)
        
        var texName: GLuint = GLuint()
        glGenTextures(1, &texName)
        glActiveTexture(GLenum(GL_TEXTURE0 + GLint(texName)))
        glBindTexture(GLenum(GL_TEXTURE_2D), texName)
        
        // Set filtering
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        
        // Set wrapping mode
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLuint(GL_RGBA), UInt32(GL_UNSIGNED_BYTE), spriteData)
        
        free(spriteData)
        return texName
    }
}