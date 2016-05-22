//
//  GameViewController.swift
//  Transverse
//
//  Created by Justin on 5/20/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import GLKit
import OpenGLES

let SHOULD_LOG_FPS : Bool = false

class GameViewController: GLKViewController {
    
    var context: EAGLContext? = nil
    var initialized: Bool = false
    var gameState: MainGameState? = nil
    
    var lastFPSCalc: Double = 0
    var frames: Int = 0
    
    deinit {
        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredFramesPerSecond = 60
        self.context = EAGLContext(API: .OpenGLES2)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .Format24
        
        self.setupGL()
        
        if (!initialized) {
            gameState = MainGameState(viewController: self)
            initialized = true
        }
        
        if (SHOULD_LOG_FPS) {
            lastFPSCalc = NSDate().timeIntervalSince1970*1000;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded() && (self.view.window != nil) {
            self.view = nil
            
            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }
    
    func setupGL() {
        EAGLContext.setCurrentContext(self.context)
        
        glClearColor(1, 1, 1, 1)
        
        print("Transverse: Loading Shaders")
        Shaders.loadShaders()
        
        print("Transverse: Loading Textures")
        Textures.loadTextures()
        
        glEnable(GLenum(GL_DITHER))
        glEnable(GLenum(GL_BLEND));
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA));
        
    }
    
    // MARK: - GLKView and GLKViewController delegate methods
    
    func update() {
        let view = self.view as! GLKView
        let width: Int32 = Int32(view.drawableWidth)
        let height: Int32 = Int32(view.drawableHeight)
        
        let projectionMatrix: GLKMatrix4 = GLKMatrix4MakeOrtho(0, Float(width), Float(height), 0, 0, 50)
        let viewMatrix: GLKMatrix4 = GLKMatrix4MakeLookAt(0, 0, 1, 0, 0, 0, 0, 1, 0)
        
        let viewProjectionMatrix: GLKMatrix4 = GLKMatrix4Multiply(projectionMatrix, viewMatrix)
        
        if let gameState = self.gameState {
            gameState.refreshDimensions(Float(width), height: Float(height), viewProjectionMatrix: viewProjectionMatrix)
        }
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        if(SHOULD_LOG_FPS) {
            frames += 1
            if (NSDate().timeIntervalSince1970*1000 - lastFPSCalc >= 1000) {
                print("Transverse FPS: \(frames)")
                frames = 0
                lastFPSCalc = NSDate().timeIntervalSince1970*1000
            }
        }
        glClearColor(1, 1, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        if let gameState = self.gameState {
            gameState.onDrawFrame()
        }
        
    }
    
    
}

