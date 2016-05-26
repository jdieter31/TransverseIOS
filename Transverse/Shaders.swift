//
//  Renderers.swift
//  Transverse
//
//  Created by Justin on 5/21/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import Foundation
import GLKit
import OpenGLES

class Shaders {
    static var solidColorProgram: GLuint = 0
    static var imageProgram: GLuint = 0
    static var solidImageProgram: GLuint = 0
    static var solidLineProgram: GLuint = 0
    static var pathProgram: GLuint = 0
    
    static var vsSolidColorHandle: GLuint = 0
    static var fsSolidColorHandle: GLuint = 0
    static var vsImageHandle: GLuint = 0
    static var fsImageHandle: GLuint = 0
    static var vsSolidImageHandle: GLuint = 0
    static var fsSolidImageHandle: GLuint = 0
    static var vsSolidLineHandle: GLuint = 0
    static var fsSolidLineHandle: GLuint = 0
    static var vsPathHandle: GLuint = 0
    static var fsPathHandle: GLuint = 0
    
    private static func loadShader(type: GLenum, file: String) -> GLuint {
        var shader : GLuint = glCreateShader(type)
        var source: UnsafePointer<Int8>
        do {
            source = try NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding).UTF8String
        } catch {
            print("Failed to load vertex shader")
            return 0;
        }
        var castSource = UnsafePointer<GLchar>(source)
        shader = glCreateShader(type)
        glShaderSource(shader, 1, &castSource, nil)
        glCompileShader(shader);
        
        return shader;
    }
    
    static func loadShaders() {
        let vsSolidColorSource = NSBundle.mainBundle().pathForResource("SolidColor", ofType: "vsh")!
        let fsSolidColorSource = NSBundle.mainBundle().pathForResource("SolidColor", ofType: "fsh")!
        
        vsSolidColorHandle = loadShader(GLenum(GL_VERTEX_SHADER), file: vsSolidColorSource);
        fsSolidColorHandle = loadShader(GLenum(GL_FRAGMENT_SHADER), file: fsSolidColorSource);
        
        solidColorProgram = glCreateProgram();             // create empty OpenGL ES Program
        glAttachShader(solidColorProgram, vsSolidColorHandle);   // add the vertex shader to program
        glAttachShader(solidColorProgram, fsSolidColorHandle); // add the fragment shader to program
        glLinkProgram(solidColorProgram);                  // creates OpenGL ES program executables
        
        let vsImageSource = NSBundle.mainBundle().pathForResource("Image", ofType: "vsh")!
        let fsImageSource = NSBundle.mainBundle().pathForResource("Image", ofType: "fsh")!
        
        // Create the shaders
        vsImageHandle = Shaders.loadShader(GLenum(GL_VERTEX_SHADER), file: vsImageSource);
        fsImageHandle = Shaders.loadShader(GLenum(GL_FRAGMENT_SHADER), file: fsImageSource);
        
        imageProgram = glCreateProgram();             // create empty OpenGL ES Program
        glAttachShader(imageProgram, vsImageHandle);   // add the vertex shader to program
        glAttachShader(imageProgram, fsImageHandle); // add the fragment shader to program
        glLinkProgram(imageProgram);                  // creates OpenGL ES program executables
        
        let vsSolidImageSource = NSBundle.mainBundle().pathForResource("SolidImage", ofType: "vsh")!
        let fsSolidImageSource = NSBundle.mainBundle().pathForResource("SolidImage", ofType: "fsh")!
        
        // Create the shaders
        vsSolidImageHandle = Shaders.loadShader(GLenum(GL_VERTEX_SHADER), file: vsSolidImageSource);
        fsSolidImageHandle = Shaders.loadShader(GLenum(GL_FRAGMENT_SHADER), file: fsSolidImageSource);
        
        solidImageProgram = glCreateProgram();             // create empty OpenGL ES Program
        glAttachShader(solidImageProgram, vsSolidImageHandle);   // add the vertex shader to program
        glAttachShader(solidImageProgram, fsSolidImageHandle); // add the fragment shader to program
        glLinkProgram(solidImageProgram);                  // creates OpenGL ES program executables
        
        let vsSolidLineSource = NSBundle.mainBundle().pathForResource("SolidLine", ofType: "vsh")!
        let fsSolidLineSource = NSBundle.mainBundle().pathForResource("SolidLine", ofType: "fsh")!
        
        // Create the shaders
        vsSolidLineHandle = Shaders.loadShader(GLenum(GL_VERTEX_SHADER), file: vsSolidLineSource);
        fsSolidLineHandle = Shaders.loadShader(GLenum(GL_FRAGMENT_SHADER), file: fsSolidLineSource);
        
        solidLineProgram = glCreateProgram();             // create empty OpenGL ES Program
        glAttachShader(solidLineProgram, vsSolidLineHandle);   // add the vertex shader to program
        glAttachShader(solidLineProgram, fsSolidLineHandle); // add the fragment shader to program
        glLinkProgram(solidLineProgram);                  // creates OpenGL ES program executables
        
        let vsPathSource = NSBundle.mainBundle().pathForResource("point", ofType: "vsh")!
        let fsPathSource = NSBundle.mainBundle().pathForResource("point", ofType: "fsh")!
        
        // Create the shaders
        vsPathHandle = Shaders.loadShader(GLenum(GL_VERTEX_SHADER), file: vsPathSource);
        fsPathHandle = Shaders.loadShader(GLenum(GL_FRAGMENT_SHADER), file: fsPathSource);
        
        pathProgram = glCreateProgram();             // create empty OpenGL ES Program
        glAttachShader(pathProgram, vsPathHandle);   // add the vertex shader to program
        glAttachShader(pathProgram, fsPathHandle); // add the fragment shader to program
        glLinkProgram(pathProgram);// creates OpenGL ES program executables
        print("\(pathProgram)")

    }
}